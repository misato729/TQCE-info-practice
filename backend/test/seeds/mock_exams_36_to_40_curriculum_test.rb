require "test_helper"
require "digest"

class MockExams36To40CurriculumTest < ActionDispatch::IntegrationTest
  EXAMS = (36..40).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_36_to_40_approved_curriculum.json"))).freeze
  CATEGORY_CODES = {
    "1.5" => "special_support_education", "1.6" => "curriculum_organization",
    "2.0" => "moral_education", "2.1" => "integrated_inquiry",
    "2.2" => "special_activities", "2.7" => "career_education",
  }.freeze

  setup do
    @entries = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
      .map { |entry| entry.merge(publication_status: "draft") }
      .select { |entry| (6..10).cover?(entry.fetch(:attributes).fetch(:question_number)) }
  end

  test "承認Markdownの独立raw保存から二十五問の本文四択正答全肢解説出典分類を比較する" do
    assert_equal 25, @entries.size
    assert_equal APPROVED.fetch("sections").keys.sort, @entries.map { |entry| key(entry) }.sort
    assert_equal "document/模試36〜40_問6〜10草案_2026-10-16.md", APPROVED.fetch("source_path")
    assert_equal "2ebbcad7ce4e73047209201c39981f037322cd9adb4e6f1b9ca8aa3402d35d10", APPROVED.fetch("sha256")
    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      raw = APPROVED.fetch("sections").fetch(id)
      head, tail = raw.split(/^正答：[アイウエ]$/, 2)
      assert head && tail, id
      assert_equal "draft", entry.fetch(:publication_status), id
      assert_equal "teacher_education", question.fetch(:major_category_code), id
      assert_equal CATEGORY_CODES.fetch(raw[/^分類：教職教養／(\d\.\d)/, 1]), question.fetch(:category_code), id
      assert_equal raw[/^正答：([アイウエ])$/, 1], question[:choices].find { |choice| choice[:correct] }.fetch(:label), id
      assert_equal %w[fill_in_text fill_in_quote], question[:content_blocks].map { |block| block[:type] }, id
      assert_equal normalize(head.lines.find { |line| line.start_with?("次の文章は") }), normalize(question[:content_blocks].first[:text]), id
      expected_quote = head.lines.grep(/^>/).map { |line| line.sub(/^> ?/, "") }.join
      assert_equal normalize(expected_quote), normalize(quote(question)), id
      rows = head.lines.grep(/^\| [アイウエ] \|/).map { |line| line.strip.split("|", -1)[1...-1].map(&:strip) }
      assert_equal rows, question[:choices].map { |choice| [choice[:label], *cells(choice)] }, id
      explanation = tail.split(/^出典：/, 2).first.strip.split(/\n{2,}/).flat_map do |paragraph|
        paragraph.start_with?("- ") ? paragraph.lines.map { |line| line.sub(/\A- /, "").strip } : paragraph
      end.map { |text| text.sub(/\A解説：/, "") }
      assert_equal explanation.map { |text| normalize(text) }, question[:explanation_blocks].map { |block| normalize(block[:text]) }, id
      assert question[:explanation_blocks].all? { |block| block[:type] == "text" }, id
      LABELS.each { |label| assert explanation.any? { |text| text.start_with?("#{label}：") }, "#{id} #{label}" }
      sources = raw.lines.grep(/^(?:出典|補助出典)：/).map do |line|
        text = line.sub(/\A(?:出典|補助出典)：/, "").strip
        link = text.match(/\[([^\]\n]+)\]\((https:\/\/[^)\n]+)\)/)
        link ? "#{link[1]} | #{link[2]}" : text
      end
      assert_equal sources.join("\n"), question.fetch(:source_text), id
      assert sources.all? { |line| line.match?(/\A.+ \| https:\/\/\S+\z/) }, id
    end
  end

  test "三又は四空欄の全トークンと各列二対二及び再露出防止と資料配分を保つ" do
    @entries.each do |entry|
      id, question = key(entry), entry[:attributes]
      count = question[:question_number] == 7 ? 3 : 4
      choices = question[:choices]
      assert_equal LABELS, choices.map { |choice| choice[:label] }, id
      assert_equal 1, choices.count { |choice| choice[:correct] }, id
      assert_equal 4, choices.map { |choice| cells(choice) }.uniq.size, id
      assert_equal BLANKS.first(count), quote(question).scan(/\{\{([^{}]+)\}\}/).flatten.uniq, id
      assert_equal ["①", BLANKS[count - 1]], question[:content_blocks].first[:text].scan(/\{\{([^{}]+)\}\}/).flatten, id
      choices.each { |choice| assert_equal [{ type: "fill_in_choice", cells: cells(choice) }], choice[:content_blocks], id; assert_equal count, cells(choice).size, id }
      count.times { |column| assert_equal [2, 2], choices.map { |choice| cells(choice)[column] }.tally.values.sort, id }
      visible = question[:content_blocks].map { |block| block[:text] }.join
      cells(choices.find { |choice| choice[:correct] }).each { |term| assert_not_includes visible, term, id }
      preview = QuestionSeedSync.preview(entry)
      QuestionWriter.validate_publication!(preview, QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys))
    end
    assert_equal 3, quote(@entries.find { |entry| key(entry) == "40-6" }[:attributes]).scan("{{②}}").size
    { 8 => [36, 39], 10 => [36, 38, 40] }.each do |number, body_exams|
      actual = @entries.select { |entry| entry[:attributes][:question_number] == number && !entry[:attributes][:content_blocks].first[:text].include?("解説") }.map { |entry| entry[:exam_number] }
      assert_equal body_exams, actual, number
    end
  end

  test "独立PDFの連続本文に正答の全空欄復元だけが一致する" do
    documents = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_36_to_40_curriculum_sources.json"))).fetch("documents")
    @entries.each do |entry|
      id, question = key(entry), entry[:attributes]
      url = question.fetch(:source_text).lines.first.split(" | ").last.strip
      base, page = url.split("#page=")
      document = documents.values.find { |item| item.fetch("url") == base }
      assert document, id
      assert_match(/\A[0-9a-f]{64}\z/, document.fetch("pdf_sha256"), id)
      pages = document.fetch("pages")
      assert pages.key?(page), id
      original = ((page.to_i - 1)..(page.to_i + 1)).filter_map do |number|
        text = pages[number.to_s]
        text = text.sub(/\A総則\n31\n/, "") if text && base.include?("20230120") && number == 33
        text
      end.join
      question[:choices].each do |choice|
        restored = quote(question).gsub(/\{\{([^{}]+)\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) }
        assert_equal choice[:correct], source_normalize(original).include?(source_normalize(restored)), "#{id} #{choice[:label]}"
      end
    end
  end

  test "必須空欄全消去セル不足未知ラベルをseed投入前に拒否する" do
    @entries.each do |entry|
      path = Rails.root.join("db/seeds/mock_exam_#{entry[:exam_number]}.rb")
      source = File.read(path)
      target = "questions.find { |question| question[:question_number] == #{entry[:attributes][:question_number]} }"
      insertion = "questions.each do |question|\n"
      assert_includes source, insertion
      mutations = [
        "#{target}[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][^{}]+[}][}]/, '語句') if block[:type] == 'fill_in_quote' }",
        "#{target}[:choices].first[:content_blocks].first[:cells].pop",
        *%w[⑤ foo].map { |label| "#{target}[:content_blocks].find { |block| block[:type] == 'fill_in_quote' }[:text] += '{{#{label}}}'" },
      ]
      mutations.each do |mutation|
        assert_raises(RuntimeError, ActiveRecord::RecordInvalid) { QuestionSeedSync.collect { eval(source.sub(insertion, mutation + "\n" + insertion), binding, path.to_s) } }
      end
    end
  end

  test "二十五問だけ同期して一般API非公開と再同期時のID履歴お気に入り保持を確認する" do
    save_entries
    user = User.create!(name: "指導要領36管理確認", email: "mock36-curriculum@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
    records = @entries.map { |entry| Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number]) }
    records.each do |record|
      user.answer_histories.create!(question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
      user.favorites.create!(question: record)
      [nil, headers].each do |auth|
        get "/api/v1/questions/#{record.id}", headers: auth
        assert_response :not_found
        assert_no_difference("AnswerHistory.count") { post "/api/v1/questions/#{record.id}/answer", params: { selected_choice_id: record.question_choices.first.id }, headers: auth, as: :json }
        assert_response :not_found
      end
    end
    [nil, headers].each do |auth|
      get "/api/v1/exams", headers: auth
      assert_response :success
      assert_empty response.parsed_body.fetch("data").map { |exam| exam.fetch("exam_number") } & EXAMS
      EXAMS.each { |exam| get "/api/v1/questions/next", params: { exam_number: exam }, headers: auth; assert_response(auth ? :not_found : :unauthorized) }
    end
    before = snapshot
    2.times do
      assert_no_difference(["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"]) { save_entries }
      assert_equal before, snapshot
    end
  end

  private

  def key(entry) = "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  def cells(choice) = choice.fetch(:content_blocks).first.fetch(:cells)
  def quote(question) = question.fetch(:content_blocks).find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
  def normalize(text) = text.to_s.gsub(/【([①②③④])】/, '{{\1}}').gsub(/[[:space:]　]+/, "")
  def source_normalize(text)
    text.unicode_normalize(:nfkc).gsub(/[[:space:]\u0000-\u001f\u007f]+/, "")
      .gsub("拓ひらく", "拓く").gsub("涵かん養", "涵養").gsub("俯ㆵ瞰ᆈ㇓", "俯瞰")
  end
  def save_entries = QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
  def snapshot = [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
end
