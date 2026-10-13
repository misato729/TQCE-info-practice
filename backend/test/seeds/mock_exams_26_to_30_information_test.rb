require "test_helper"
require "digest"

class MockExams26To30InformationTest < ActiveSupport::TestCase
  EXAMS = (26..30).to_a.freeze
  NUMBERS = [16, 17, 18].freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③].freeze
  COUNT_KEYS = %w[28-17 30-18].freeze
  EDITED_KEY = "30-17".freeze
  ANSWERS = { 26 => %w[ア ウ イ], 27 => %w[ウ エ ア], 28 => %w[ウ イ ウ],
    29 => %w[イ エ ア], 30 => %w[エ ア ウ] }.freeze
  SCOPES = { 26 => %w[A B C], 27 => %w[A B D], 28 => %w[A C D],
    29 => %w[B C D], 30 => %w[A B C] }.freeze
  EDUCATION_KEYS = %w[26-17 27-16 27-17 28-16 29-16 30-16 30-17 30-18].freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_approved_information_drafts.json"))).freeze
  SOURCES = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_information_sources.json"))).freeze

  setup do
    @all_entries = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
    @entries = @all_entries.select { |entry| NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認十五問の導入本文三記述全四肢正答解説出典分類をseed非依存草案と照合する" do
    assert_equal 15, @entries.size
    assert_equal APPROVED.fetch("sections").keys.sort, @questions.keys.sort
    assert_equal "adc368e57f2601f456dc179c97345da5b05b2d9eb444085a0eb181790db61756", APPROVED.fetch("sha256")
    @questions.each do |id, question|
      draft = APPROVED.fetch("sections").fetch(id)
      head, tail = draft.split(/^正答：[アイウエ].*$/, 2)
      prompt = head.lines.find { |line| line.start_with?("次の文章は", "『高等学校") }
      assert_equal normalize(prompt), normalize(question[:content_blocks].first.fetch(:text)), id
      assert_equal "information", question.fetch(:major_category_code), id
      assert_equal EDUCATION_KEYS.include?(id) ? "information_education" : "information_specialized", question.fetch(:category_code), id
      assert_equal draft[/^正答：([アイウエ])/, 1], answer(question).fetch(:label), id
      if COUNT_KEYS.include?(id)
        assert_equal "text", question[:content_blocks].first[:type], id
        assert_equal %w[text fill_in_quote], question[:content_blocks].map { |block| block[:type] }, id
        expected = head.lines.grep(/^[①②③]　/).map { |line| normalize(line) }
        assert_equal expected, quote(question).lines.grep(/^[①②③]　/).map { |line| normalize(line) }, id
        rows = head.scan(/^([アイウエ])　([^\n]+)/).map { |label, text| [label, normalize(text)] }
        assert_equal rows, question[:choices].map { |choice| [choice[:label], normalize(choice[:content_blocks].first.fetch(:text))] }, id
      else
        assert_equal %w[fill_in_text fill_in_quote], question[:content_blocks].map { |block| block[:type] }, id
        expected_quote = head.lines.grep(/^>/).map { |line| line.sub(/^> ?/, "") }.join
        assert_equal normalize(expected_quote), normalize(quote(question)), id
        rows = head.lines.grep(/^\| [アイウエ] \|/).map { |line| markdown_row(line) }
        assert_equal rows, question[:choices].map { |choice| [choice[:label], *cells(choice)] }, id
      end
      expected_explanation = tail.split(/^出典：/, 2).first.strip.sub(/\A解説：/, "").gsub(/^- /, "")
      assert_equal normalize(expected_explanation), normalize(question[:explanation_blocks].map { |block| block.fetch(:text) }.join("\n")), id
      expected_sources = draft.lines.grep(/^source_text：/).map { |line| line.sub(/^source_text：/, "").strip }.join("\n")
      assert_equal expected_sources, question.fetch(:source_text), id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/www\.mext\.go\.jp\/\S+\z/) }, id
      assert_equal LABELS, question[:choices].map { |choice| choice.fetch(:label) }, id
      assert_equal 1, question[:choices].count { |choice| choice.fetch(:correct) }, id
      preview = QuestionSeedSync.preview(@entries.find { |entry| key(entry) == id })
      choices = QuestionPayload.from_seed(preview.exam_number, question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
  end

  test "十二原文穴埋めは正答一行だけが独立PDF全文の連続範囲に一致する" do
    raw = @questions.except(*COUNT_KEYS, EDITED_KEY)
    assert_equal 12, raw.size
    raw.each do |id, question|
      original = original_pages(id)
      assert_includes question[:content_blocks].first[:text], "からの抜粋である。", id
      assert_no_match(/中略|図[0-9０-９]+参照|内容の[（(]|〔指導項目〕/, quote(question), id)
      matches = question[:choices].count do |choice|
        found = original.include?(source_normalize(restore(question, choice)))
        assert_equal choice[:correct], found, "#{id} #{choice[:label]}"
        found
      end
      assert_equal 1, matches, id
    end
    SOURCES.fetch("documents").each do |name, document|
      assert_match(/\Ahttps:\/\/www\.mext\.go\.jp\//, document.fetch("url"), name)
      assert_match(/\A[0-9a-f]{64}\z/, document.fetch("pdf_sha256"), name)
      assert document.fetch("pages").any?, name
    end
    assert_equal "59ef17a825bd11a4fa39ed2cc1f27033c83a95e4e93f0f8a821a65e063bb2512", SOURCES.dig("documents", "curriculum", "pdf_sha256")
    assert_equal "0a95db55b9ec0570ac4b47586d9f6342c82a0ec5e7c0b071111208ae6e09d443", SOURCES.dig("documents", "information", "pdf_sha256")
    assert_equal 17, SOURCES.fetch("documents").values.sum { |document| document.fetch("pages").size }
  end

  test "参照展開は独立原文と参照先の内容名から明示的に変換し抜粋と混同しない" do
    question = @questions.fetch(EDITED_KEY)
    location = SOURCES.fetch("locations").fetch(EDITED_KEY)
    original = original_pages(EDITED_KEY)
    start = original.index(source_normalize("〔指導項目〕の（2）のアについては"))
    ending = source_normalize("安全かつ有効な共有と活用について扱うこと。")
    assert start
    stop = original.index(ending, start)
    assert stop
    original = original[start...(stop + ending.length)]
    reference = source_normalize(SOURCES.dig("documents", "curriculum", "pages", "411"))
    assert_equal [411], location.fetch("reference_pdf_pages")
    mappings = location.fetch("reference_mapping")
    assert_includes reference, source_normalize("（2）情報の管理ア情報の管理とドキュメンテーションイコンピュータによる情報の管理と活用ウ情報の保護とセキュリティ")
    expanded = original.sub(source_normalize("〔指導項目〕の（2）のア"), source_normalize(mappings.fetch("〔指導項目〕の（2）のア")))
      .sub(source_normalize("イについては"), source_normalize("#{mappings.fetch('イ')}については"))
      .sub(source_normalize("ウについては"), source_normalize("#{mappings.fetch('ウ')}については"))
    question[:choices].each do |choice|
      assert_equal choice[:correct], expanded == source_normalize(restore(question, choice)), choice[:label]
    end
    assert_includes question[:content_blocks].first[:text], "示された内容に基づく記述である。"
    assert_not_includes question[:content_blocks].first[:text], "からの抜粋"
    assert_no_match(/〔指導項目〕|の[（(]2[）)]の[アイウ]/, quote(question))
    assert_includes question[:source_text], "項番の参照を内容名に展開"
  end

  test "十三穴埋めの三空欄三セル各列二対二正答再掲防止と繰り返す同番号を維持する" do
    questions = @questions.except(*COUNT_KEYS)
    assert_equal 13, questions.size
    questions.each do |id, question|
      labels = quote(question).scan(/\{\{([①②③])\}\}/).flatten.uniq
      assert_equal BLANKS, labels, id
      assert_equal %w[① ③], question[:content_blocks].first[:text].scan(/\{\{([①②③])\}\}/).flatten.uniq, id
      choices = question.fetch(:choices)
      assert_equal 4, choices.map { |choice| cells(choice) }.uniq.size, id
      choices.each do |choice|
        assert_equal 1, choice[:content_blocks].size, id
        assert_equal "fill_in_choice", choice[:content_blocks].first[:type], id
        assert_equal 3, cells(choice).size, id
      end
      choices.map { |choice| cells(choice) }.transpose.each_with_index do |column, index|
        assert_equal [2, 2], column.tally.values.sort, "#{id} 列#{index + 1}"
      end
      visible = question[:content_blocks].map { |block| block.fetch(:text) }.join
      cells(answer(question)).each { |term| assert_not_includes visible, term, id }
      LABELS.each { |label| assert_match(/#{label}：/, question[:explanation_blocks].map { |block| block[:text] }.join, id) }
      assert_not question[:content_blocks].any? { |block| block[:type] == "quote" }, id
    end
    assert_equal 2, quote(@questions.fetch("28-16")).scan("{{①}}").size
    assert_includes cells(answer(@questions.fetch("28-18")))[1], "実態関連図"
    assert_not_includes cells(answer(@questions.fetch("28-18")))[1], "実体関連図"
  end

  test "R8型個数二問の三記述はCPUメモリOSと数学科関連の独立原典対応を根拠とする" do
    COUNT_KEYS.each do |id|
      question = @questions.fetch(id)
      assert_equal %w[三つ 二つ 一つ なし], question[:choices].map { |choice| choice[:content_blocks].first.fetch(:text) }, id
      assert_equal %w[text fill_in_quote], question[:content_blocks].map { |block| block[:type] }, id
      assert_equal 3, quote(question).lines.grep(/^[①②③]　/).size, id
      %w[① ② ③].each { |label| assert quote(question).lines.any? { |line| line.start_with?("#{label}　") }, id }
      assert_no_match(/\{\{/, quote(question), id)
      LABELS.each { |label| assert_match(/選択肢#{label}/, question[:explanation_blocks].map { |block| block[:text] }.join, id) }
    end
    original = original_pages("28-17")
    ["ソフトウェアはオペレーティングシステムの機能を利用して動作していること", "データがCPU，メモリ，周辺装置の間でやり取りされていること", "コンピュータがデータを処理する作業場所としてのメモリの役割", "CPUが機械語のプログラムをデータとして読みながら実行すること"].each do |passage|
      assert_includes original, source_normalize(passage)
    end
    assert_equal "イ", answer(@questions.fetch("28-17"))[:label]
    explanation = @questions.fetch("28-17")[:explanation_blocks].map { |block| block[:text] }.join
    assert_includes explanation, "記述①・②が正しく，③が誤り"
    sources = SOURCES.dig("documents", "information", "pages")
    assert_match(/情報通信ネットワークとデータの活用.*数学I.*データの分析/, source_normalize(sources.fetch("71")))
    assert_match(/数学B.*統計的な推測.*関連が深い/, source_normalize(sources.fetch("57")))
    assert_match(/モデル化とシミュレーション.*数学A.*場合の数と確率.*関連が深く/, source_normalize(sources.fetch("40")))
    assert_equal "ウ", answer(@questions.fetch("30-18"))[:label]
    explanation = @questions.fetch("30-18")[:explanation_blocks].map { |block| block[:text] }.join
    assert_includes explanation, "記述①が正しく，②・③"
    assert_includes explanation, "「数学B」の「統計的な推測」"
    assert_includes explanation, "「数学A」の「場合の数と確率」"
  end

  test "各セットは相異なる三範囲を資料項目順に出し承認正答順を保つ" do
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ANSWERS.fetch(exam), entries.map { |entry| answer(entry[:attributes])[:label] }, exam
      scopes = entries.map { |entry| SOURCES.fetch("locations").fetch(key(entry)).fetch("scope") }
      assert_equal SCOPES.fetch(exam), scopes, exam
      assert_equal scopes.uniq.sort, scopes, exam
      entries.each do |entry|
        scope, prompt = SOURCES.fetch("locations").fetch(key(entry)).fetch("scope"), entry[:attributes][:content_blocks].first[:text]
        phrase = { "A" => "第2章 各学科に共通する各教科 第10節 情報", "B" => "第3章 主として専門学科において開設される各教科 第7節 情報", "C" => "第1部 各学科に共通する教科", "D" => "第2部 主として専門学科において開設される教科" }.fetch(scope)
        assert_includes prompt, phrase, key(entry)
        assert_match(/(?:1 目標|3 内容の取扱い)/, prompt, key(entry)) if scope == "B"
      end
    end
  end

  test "既存七十五問と新規十五問の本文四択に完全重複がない" do
    previous = QuestionSeedSync.collect { (1..25).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
      .select { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }
    assert_equal 75, previous.size
    fingerprints = (previous + @entries).map do |entry|
      question = entry.fetch(:attributes)
      normalize([question[:content_blocks], question[:choices].map { |choice| choice[:content_blocks] }].to_json)
    end
    assert_equal 90, fingerprints.uniq.size
  end

  test "十三問の全実空欄除去又は一列不足はDB保存前にseedで拒否する" do
    @entries.reject { |entry| COUNT_KEYS.include?(key(entry)) }.each do |entry|
      path = Rails.root.join("db/seeds/mock_exam_#{entry[:exam_number]}.rb")
      source, number = File.read(path), entry[:attributes][:question_number]
      mutations = [
        "questions.find { |question| question[:question_number] == #{number} }[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][①②③][}][}]/, '語句') if block[:type] == 'fill_in_quote' }\n",
        "questions.find { |question| question[:question_number] == #{number} }[:choices].first[:content_blocks].first[:cells].pop\n",
      ]
      assert_includes source, "questions.each do |question|\n", key(entry)
      mutations.each do |mutation|
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
          assert_raises(RuntimeError, ActiveRecord::RecordInvalid) do
            QuestionSeedSync.collect { eval(source.sub("questions.each do |question|\n", mutation + "questions.each do |question|\n"), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "問三から二十の十八問下書き段階では問一二不足による公開拒否が全データを保持する" do
    # Explicitly retain this historical partial stage even after later
    # approval completes and publishes the live seed. Do not depend on its
    # current publication_status or delete future Q1/Q2 from real data.
    staged = @all_entries.select { |entry| (3..20).cover?(entry[:attributes][:question_number]) }
      .map { |entry| entry.merge(publication_status: "draft") }
    assert_equal 90, staged.size
    QuestionWriter.transaction { staged.each { |entry| QuestionSeedSync.call(**entry) } }
    EXAMS.each do |exam|
      records = Question.where(exam_number: exam)
      assert_equal (3..20).to_a, records.order(:question_number).pluck(:question_number), exam
      assert_equal 18, records.where(publication_status: "draft").count, exam
      assert_equal 0, records.where(publication_status: "published").count, exam
    end
    user = User.create!(name: "情報科未完公開確認", email: "mock26-information-incomplete@example.com", password: "password123", password_confirmation: "password123")
    EXAMS.each do |exam|
      record = Question.find_by!(exam_number: exam, question_number: 16)
      user.answer_histories.create!(question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
      user.favorites.create!(question: record)
    end
    before = database_snapshot
    EXAMS.each do |exam|
      record = Question.find_by!(exam_number: exam, question_number: 16)
      payload = QuestionPayload.from_record(record).merge("publication_status" => "published")
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        error = assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(record, payload, require_complete_exam: true) }
        assert_includes error.message, "問1〜20の登録が必要"
        assert_includes error.message, "不足：問1、問2"
      end
      assert_equal "draft", record.reload.publication_status, exam
      assert_equal before, database_snapshot, exam
    end
  end

  private

  def key(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def answer(question)
    question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def cells(choice)
    choice.fetch(:content_blocks).first.fetch(:cells)
  end

  def quote(question)
    question.fetch(:content_blocks).find { |block| block.fetch(:type) == "fill_in_quote" }.fetch(:text)
  end

  def restore(question, choice)
    BLANKS.zip(cells(choice)).reduce(quote(question)) { |text, (label, cell)| text.gsub("{{#{label}}}", cell) }
  end

  def markdown_row(line)
    line.strip.split("|", -1)[1...-1].map(&:strip)
  end

  def normalize(text)
    text.to_s.gsub(/\{\{([①②③])\}\}|【([①②③])】/) { Regexp.last_match(1) || Regexp.last_match(2) }.gsub(/[[:space:]　]+/, "")
  end

  def source_normalize(text)
    text.to_s.unicode_normalize(:nfkc).gsub(/[[:space:]　\u0007]+/, "")
  end

  def original_pages(id)
    location = SOURCES.fetch("locations").fetch(id)
    document = SOURCES.fetch("documents").fetch(location.fetch("document"))
    location.fetch("pdf_pages").map do |page|
      lines = document.fetch("pages").fetch(page.to_s).lines
      if location.fetch("document") == "curriculum"
        lines.shift while lines.any? && (lines.first.strip == "情報" || lines.first.strip.match?(/\A\d+\z/))
      end
      source_normalize(lines.join)
    end.join
  end

  def database_snapshot
    [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h do |model|
      [model.name, model.order(:id).map(&:attributes)]
    end
  end
end
