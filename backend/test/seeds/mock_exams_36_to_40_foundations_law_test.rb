require "test_helper"
require "digest"

class MockExams36To40FoundationsLawTest < ActionDispatch::IntegrationTest
  EXAMS = (36..40).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_36_to_40_approved_foundations_law.json"))).freeze

  setup do
    @entries = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
  end

  test "承認二十五問の本文選択肢全肢解説出典を独立Markdown保存と照合する" do
    assert_equal 25, @entries.size
    assert_equal APPROVED.fetch("sections").keys.sort, @entries.map { |e| key(e) }.sort
    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      draft = APPROVED.fetch("sections").fetch(id)
      answer_match = draft.match(/^正答：([アイウエ])$/)
      head, tail = draft[0...answer_match.begin(0)], draft[answer_match.end(0)..]
      start = head.index(/^\| (?:記号|選択肢) \|/) || head.index(/^[アイウエ]　/)
      expected_stem = head[0...start].gsub(/^> ?/, "").gsub(/【([^】]+)】/, '{{\1}}')
      assert_equal canonical(expected_stem), canonical(question[:content_blocks].map { |b| b[:text] }.join("\n\n")), id
      assert_equal answer_match[1], question[:choices].find { |c| c[:correct] }[:label], id
      assert_equal LABELS, question[:choices].map { |c| c[:label] }, id
      assert_equal 1, question[:choices].count { |c| c[:correct] }, id
      assert_equal "draft", entry[:publication_status], id
      assert_equal "teacher_education", question[:major_category_code], id
      assert_equal question[:question_number] <= 2 ? "education_foundations" : "education_system", question[:category_code], id

      rows = head.scan(/^\|\s*([アイウエ])\s*\|(.+)\|\s*$/)
      if rows.any?
        assert_equal rows.map { |label, cells| [label, cells.split("|").map(&:strip)] }, question[:choices].map { |c| [c[:label], c[:content_blocks].first[:cells]] }, id
        quotes = question[:content_blocks].select { |b| b[:type] == "fill_in_quote" }
        assert_equal LABELS.size, question[:choices].map { |c| c[:content_blocks] }.uniq.size, id
        assert_equal %w[① ② ③ ④], quotes.flat_map { |b| b[:text].scan(/\{\{([^{}]+)\}\}/).flatten }.uniq, id
        assert_equal "fill_in_text", question[:content_blocks].first[:type], id
        assert quotes.all? { |b| b[:text].match?(/\A第\d+条/) }, id
        question[:choices].each { |c| assert_equal "fill_in_choice", c[:content_blocks].first[:type], id }
      else
        assert_equal head.scan(/^([アイウエ])　(.+)$/), question[:choices].map { |c| [c[:label], c[:content_blocks].first[:text]] }, id
        question[:choices].each { |c| assert_equal "text", c[:content_blocks].first[:type], id }
      end

      source = tail.match(/^(?:\#{1,4} )?出典[^\n]*/)
      expected_explanation = tail[0...source.begin(0)].sub(/\A\s*(?:\#{1,4} )?解説[：:]?\s*\n/, "").gsub(/^- /, "")
      assert_equal canonical(expected_explanation), canonical(question[:explanation_blocks].map { |b| b[:text] }.join("\n\n")), id
      LABELS.each { |label| assert question[:explanation_blocks].any? { |b| b[:text].start_with?("#{label}：") }, id }
      source_area = tail[source.begin(0)..].split(/^\#{1,4} (?:既|作問|確認)/, 2).first
      links = source_area.lines.select { |line| line.include?("](https://") }.flat_map { |line| line.scan(/\[([^\]]+)\]\((https:\/\/[^\s)]+)\)/) }
      assert_equal links.map { |title, url| "#{title} | #{url}" }.join("\n"), question[:source_text], id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      payload = QuestionPayload.from_seed(entry[:exam_number], question)
      QuestionWriter.validate_choices!(QuestionSeedSync.preview(entry), payload.fetch("choices").map(&:deep_symbolize_keys))
    end
    assert_equal 2, @entries.find { |e| key(e) == "36-4" }[:attributes][:content_blocks].count { |b| b[:type] == "fill_in_quote" }
    count = @entries.find { |e| key(e) == "38-3" }[:attributes]
    assert_equal "text", count[:content_blocks].first[:type]
    assert_equal %w[① ② ③], count[:content_blocks].last[:text].scan(/^([①②③])　/).flatten
    assert_equal 7, count[:explanation_blocks].size
  end

  test "各五問だけを下書き保存し再実行でも増殖せず一般APIに出さない" do
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
    scope = Question.where(exam_number: EXAMS)
    assert_equal 25, scope.count
    assert_equal 25, scope.where(publication_status: "draft").count
    assert_equal 0, scope.published.count
    ids = scope.order(:exam_number, :question_number).pluck(:id)
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
    assert_equal ids, scope.order(:exam_number, :question_number).pluck(:id)
    EXAMS.each do |exam|
      assert_equal (1..5).to_a, scope.where(exam_number: exam).order(:question_number).pluck(:question_number)
      question = scope.find_by!(exam_number: exam, question_number: 1)
      get "/api/v1/questions/#{question.id}"
      assert_response :not_found
      assert_not response.parsed_body.key?("data")
    end
  end

  private

  def key(entry)
    "#{entry[:exam_number]}-#{entry[:attributes][:question_number]}"
  end

  def canonical(text)
    text.gsub(/[[:space:]　]/, "")
  end
end
