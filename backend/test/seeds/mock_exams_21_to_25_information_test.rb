require "test_helper"

class MockExams21To25InformationTest < ActionDispatch::IntegrationTest
  EXAMS = (21..25).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  ANSWERS = { 21 => %w[イ ウ エ ア イ], 22 => %w[ア エ ウ イ ア],
    23 => %w[ウ イ ウ ウ イ], 24 => %w[エ ア エ ア ウ], 25 => %w[イ ア イ エ ウ] }.freeze
  SOURCE_ORDER = { 21 => [0,1,2], 22 => [0,1,3], 23 => [0,2,3],
    24 => [1,2,3], 25 => [0,1,2] }.freeze
  APPROVED = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_21_to_25_information_approved.json", __dir__))).freeze
  ORIGINALS = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_21_to_25_information_source_pages.json", __dir__))).freeze

  setup do
    @entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @added = @entries.select { |entry| entry[:attributes][:question_number] >= 16 }
  end

  test "承認済み二十五問の全文を草案由来の固定資料と照合する" do
    expected = APPROVED.fetch("questions").to_h { |row| ["#{row['exam']}-#{row.dig('attributes','question_number')}", row.fetch("attributes")] }
    assert_equal 25, @added.size
    @added.each do |entry|
      question = entry.fetch(:attributes)
      assert_equal expected.fetch(key(entry)), question.deep_stringify_keys, key(entry)
      assert_equal "published", entry[:publication_status]
      assert_equal LABELS, question[:choices].map { |choice| choice[:label] }
      assert_equal 1, question[:choices].count { |choice| choice[:correct] }
      assert_equal 4, question[:choices].map { |choice| choice[:content_blocks] }.uniq.size
      question[:source_text].lines.each { |line| assert_match(/\A.+ \| https:\/\/\S+\z/, line.strip) }
      assert_not question[:content_blocks].any? { |block| block[:type] == "quote" }
    end
  end

  test "五セットは全二十問が揃い正答各五件と資料順を満たす" do
    assert_equal 100, @entries.size
    EXAMS.each do |exam|
      rows = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal (1..20).to_a, rows.map { |entry| entry[:attributes][:question_number] }
      assert_equal LABELS.to_h { |label| [label,5] }, rows.map { |entry| correct(entry)[:label] }.tally
      assert_equal ANSWERS.fetch(exam), rows.last(5).map { |entry| correct(entry)[:label] }
      assert_equal SOURCE_ORDER.fetch(exam), rows[15,3].map { |entry| source_index(entry) }
      rows.last(2).each { |entry| assert_equal "information_specialized", entry[:attributes][:category_code] }
    end
    guidance = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_21_to_25_guidance_psychology_report_approved.json", __dir__)))
    guidance.fetch("questions").each do |row|
      assert_equal row.fetch("attributes"), entry(row.fetch("exam"), row.dig("attributes","question_number"))[:attributes].deep_stringify_keys
    end
    actual_digests = @entries.select { |row| row[:attributes][:question_number] <= 10 }.to_h do |row|
      [key(row), QuestionPayload.digest(QuestionPayload.from_seed(row[:exam_number], row[:attributes]))]
    end
    assert_equal guidance.fetch("existing_1_to_10_digests"), actual_digests
  end

  test "原文十問は独立した公式PDF本文の連続範囲と一致する" do
    raw = @added.select { |row| row[:attributes][:question_number] <= 18 && !ORIGINALS.fetch(key(row)).fetch("edited") && !ORIGINALS.fetch(key(row)).fetch("count") }
    assert_equal 10, raw.size
    raw.each do |row|
      restored = quote(row).gsub(/\{\{([①②③])\}\}/) { cells(correct(row)).fetch(%w[① ② ③].index(Regexp.last_match(1))) }
      assert_includes normalize(ORIGINALS.fetch(key(row)).fetch("text")), normalize(restored), key(row)
      assert_includes row[:attributes][:content_blocks].first[:text], "からの抜粋である。"
    end
  end

  test "項番展開四問を原文抜粋と呼ばず参照先と原典の対応を保つ" do
    { "21-16" => ["コンテンツに対する要求を整理する活動も取り入れるものとする。", "発信者，受信者双方の視点からコンテンツを評価する活動を取り入れるものとする。"],
      "22-17" => ["プロジェクトマネジメントなどを扱うこと。", "情報システムの運用と保守に必要なドキュメントについても触れること。", "情報産業に携わる者に求められる倫理観にも触れること。"],
      "24-16" => ["実機若しくはインターネット上のサーバ又はその両方を扱うこと。", "公開を前提としたサーバのアクセス制御，暗号化などのセキュリティ対策について扱うこと。"],
      "25-16" => ["情報と情報技術を活用した問題発見・解決の探究"] }.each do |id, phrases|
      row = entry(*id.split("-").map(&:to_i))
      assert_includes row[:attributes][:content_blocks].first[:text], "に示された内容に基づく記述である。"
      restored = quote(row).gsub(/\{\{([①②③])\}\}/) { cells(correct(row)).fetch(%w[① ② ③].index(Regexp.last_match(1))) }
      phrases.each do |phrase|
        assert_includes normalize(ORIGINALS.fetch(id).fetch("text")), normalize(phrase)
        assert_includes normalize(restored), normalize(phrase)
      end
    end
    source = normalize(ORIGINALS.fetch("25-18").fetch("text"))
    assert_includes source, normalize("測定しようとするもの以外で結果に影響を与える交絡因子")
    %w[選択バイアス 情報バイアス 過少申告 過剰反応].each { |term| assert_includes source, term }
  end

  test "空欄は本文と選択肢に対応し再登場も伏せ各列は二対二になる" do
    cloze = @added.select { |row| correct(row)[:content_blocks].first[:type] == "fill_in_choice" }
    assert_equal 17, cloze.size
    cloze.each do |row|
      question = row[:attributes]
      label_set = question[:content_blocks].drop(1).flat_map do |block|
        block[:type] == "code" ? block[:code].scan(/【([①②③])】/).flatten : block.fetch(:text, "").scan(/\{\{([①②③])\}\}/).flatten
      end.uniq
      assert_equal %w[① ② ③].first(cells(correct(row)).size), label_set, key(row)
      question[:choices].map { |choice| cells(choice) }.transpose.each { |column| assert_equal [2,2], column.tally.values.sort }
    end
    assert_equal 2, quote(entry(21,17)).scan("{{①}}").size
    assert_equal 3, quote(entry(21,18)).scan("{{①}}").size
  end

  test "表示プログラムの全穴埋め候補を実行し正答と誤答を検算する" do
    expected = {21 => [[5,3,8,2,7]], 23 => [3], 24 => [[2,0]]}
    described = {21 => [[[5,3,8,2,7]],[[7,3,8,2,7]],[[5,3,3,3,3]],[[3,3,3,3,3]]],
      23 => [[2],[2],[3],[1]], 24 => [[[2,0]],[[3,1]],[[5,11]],[[4,11]]]}
    expected.each do |exam, target|
      row = entry(exam,19)
      row[:attributes][:choices].each_with_index do |choice,index|
        source = program(row).gsub(/【([①②])】/) { cells(choice).fetch(%w[① ②].index(Regexp.last_match(1))) }
        output = execute(source)
        assert_equal described.fetch(exam).fetch(index), output, "#{exam}-19 #{choice[:label]}"
        assert_equal choice[:correct], output == target
      end
    end
    row = entry(22,19)
    lines = program(row).lines.map(&:chomp)
    variants = []
    variants << lines.map { |line| line == "    print(s)" ? "        print(s)" : line }
    variant = lines.dup; variant.delete_at(1); variant.insert(2,"    s = 0"); variants << variant
    variant = lines.dup; variant.delete_at(1); variant.insert(3,"        s = 0"); variants << variant
    variants << lines.map { |line| line == "    print(s)" ? "print(s)" : line }
    expected_rows = [[2,7,8,12,15,17,23,24,28],[8,9,11],[1,2,4],[28]]
    variants.each_with_index do |source,index|
      output = execute(source.join("\n"))
      assert_equal expected_rows[index], output
      assert_equal row[:attributes][:choices][index][:correct], output == [[2,5,1],[4,3,2],[6,1,4]].map(&:sum)
    end
    row = entry(25,19)
    result = execute(program(row)).last
    assert_equal 22, result
    assert_equal 18, execute(program(row).sub("s = 1", "s = 0")).last
    row[:attributes][:choices].each { |choice| assert_equal choice[:correct], choice[:content_blocks].first[:text].to_i == result }
  end

  test "問二十の数値と分類を表示データから再計算する" do
    rows = table(entry(21,20))[:rows].map { |row| row.drop(1).map(&:to_i) }
    assert_equal [65,80], rows.map { |row| row.last - row.first }
    assert_equal [35,20], rows.map { |row| row[3] - row[1] }
    assert_equal %w[離散型の量的データ 連続型の量的データ 質的データ], correct(entry(22,20))[:content_blocks].first[:rows].first
    times = table(entry(23,20))[:rows].first.drop(1).reject { |cell| cell == "未回答" }.map(&:to_i)
    assert_equal 5, times.size
    assert_equal 24, times.sum.fdiv(times.size)
    assert_equal 40, times.select(&:positive?).sum.fdiv(3)
    counts = table(entry(24,20))[:rows].map { |row| row.last.to_i }
    assert_equal 20, counts.sum
    assert_equal 65, counts.first(2).sum.fdiv(counts.sum) * 100
    assert_equal 35, counts.last(2).sum.fdiv(counts.sum) * 100
    observations = table(entry(25,20))[:rows].map { |row| row.drop(1).map(&:to_i) }
    assert_equal [14,20], observations.map { |x,_| 8 + 3*x }
    assert_equal [2,-2], observations.map { |x,y| y - (8 + 3*x) }
  end

  test "有料会員は追加二十五問を取得採点でき無料側には内容を渡さない" do
    synchronize
    user = User.create!(name: "追加問題検査", email: "completed-21-25@example.com", password: "password123", password_confirmation: "password123")
    paid = {"Authorization" => "Bearer #{AuthToken.issue(user)}"}
    payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_completed_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    user.create_membership!(source_payment: payment, status: "active", activated_at: Time.current)
    free_user = User.create!(name: "無料側検査", email: "completed-free@example.com", password: "password123", password_confirmation: "password123")
    free = {"Authorization" => "Bearer #{AuthToken.issue(free_user)}"}
    get api_v1_exams_path, headers: paid
    assert_response :success
    assert_equal EXAMS, response.parsed_body.fetch("data").map { |exam| exam.fetch("exam_number") } & EXAMS
    @added.each do |row|
      question = Question.find_by!(exam_number: row[:exam_number], question_number: row[:attributes][:question_number])
      get api_v1_question_path(question)
      assert_response :unauthorized
      assert_not response.parsed_body.key?("data")
      get api_v1_question_path(question), headers: free
      assert_response :forbidden
      assert_not response.parsed_body.key?("data")
      get api_v1_question_path(question), headers: paid
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal question.content_blocks, body.fetch("content_blocks")
      %w[correct_choice explanation_blocks source_text].each { |field| assert_not body.key?(field) }
      question.question_choices.each do |choice|
        post answer_api_v1_question_path(question), params: {selected_choice_id: choice.id}, headers: paid, as: :json
        assert_response :success
        answer = response.parsed_body.fetch("data")
        assert_equal choice.is_correct?, answer.fetch("is_correct")
        assert_equal question.explanation_blocks, answer.fetch("explanation_blocks")
        assert_equal question.source_text, answer.fetch("source_text")
      end
    end
  end

  test "完成seedの再実行は件数とIDと回答履歴を保持する" do
    synchronize
    ids = Question.where(exam_number: EXAMS).order(:id).pluck(:id)
    choices = QuestionChoice.where(question_id: ids).order(:id).pluck(:id)
    user = User.create!(name: "再投入検査", email: "completed-reseed@example.com", password: "password123", password_confirmation: "password123")
    question = Question.find_by!(exam_number: 25, question_number: 20)
    history = AnswerHistory.create!(user: user, question: question, selected_choice: question.question_choices.first, is_correct: false)
    2.times do
      assert_no_difference(["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"]) { synchronize }
      assert_equal ids, Question.where(exam_number: EXAMS).order(:id).pluck(:id)
      assert_equal choices, QuestionChoice.where(question_id: ids).order(:id).pluck(:id)
      assert AnswerHistory.exists?(history.id)
    end
  end

  private

  def entry(exam, number)
    @entries.find { |row| row[:exam_number] == exam && row[:attributes][:question_number] == number } or raise "missing question"
  end
  def key(row) = "#{row[:exam_number]}-#{row[:attributes][:question_number]}"
  def correct(row) = row[:attributes][:choices].find { |choice| choice[:correct] }
  def cells(choice) = choice[:content_blocks].first.fetch(:cells)
  def quote(row) = row[:attributes][:content_blocks].find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
  def table(row) = row[:attributes][:content_blocks].find { |block| block[:type] == "table" }
  def program(row) = row[:attributes][:content_blocks].find { |block| block[:type] == "code" }.fetch(:code).lines.map { |line| line.sub(/\A\d{2} /, "") }.join
  def normalize(text) = text.unicode_normalize(:nfkc).gsub(/[\s\u0000-\u001f]/, "")
  def synchronize = QuestionWriter.transaction { @entries.each { |row| QuestionSeedSync.call(**row) } }
  def source_index(row)
    prompt = row[:attributes][:content_blocks].first[:text]
    prompt.include?("解説 情報編") ? (prompt.include?("第1部") ? 2 : 3) : (prompt.include?("第2章") ? 0 : 1)
  end

  # Execute the displayed, small Python-like subset after mechanical conversion
  # to Ruby. Expected results above are independent of the correct-choice flag.
  def execute(source)
    source.scan(/^\s*([A-Z]\w*) =/).flatten.uniq.each do |name|
      source = source.gsub(/\b#{Regexp.escape(name)}\b/, "q19_#{name.downcase}")
    end
    outputs = []
    scope = Object.new
    scope.define_singleton_method(:range) do |a,b,step=1|
      values = []; value = a
      while step.positive? ? value < b : value > b
        values << value; value += step
      end
      values
    end
    scope.define_singleton_method(:print) { |*args| outputs << Marshal.load(Marshal.dump(args.size == 1 ? args.first : args)) }
    # Python assignments inside loops remain in the surrounding scope; Ruby's
    # block-local first assignments need their names declared in that scope.
    translated = source.scan(/^\s*(\w+) =/).flatten.uniq.map { |name| "#{name} = nil" }
    stack = []
    source.lines.each do |line|
      next if line.strip.empty?
      indent, text = line[/\A */].size, line.strip
      while stack.any? && indent <= stack.last && !(text == "else:" && indent == stack.last)
        translated << "end"; stack.pop
      end
      text = text.gsub(/len\((\w+)\)/, '\\1.length').gsub(/\band\b/, '&&')
      case text
      when /\Afor (\w+) in (.+):\z/
        translated << "#{$2}.each do |#{$1}|"; stack << indent
      when /\A(?:if|while|def) .+:\z/
        translated << text.delete_suffix(":"); stack << indent
      when "else:"
        translated << "else"
      else
        translated << text
      end
    end
    translated.concat(Array.new(stack.size, "end"))
    scope.instance_eval(translated.join("\n"))
    outputs
  end
end
