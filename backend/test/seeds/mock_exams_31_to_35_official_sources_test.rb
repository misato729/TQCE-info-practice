require "test_helper"

class MockExams31To35OfficialSourcesTest < ActiveSupport::TestCase
  EXAMS = (31..35).to_a.freeze
  BLANKS = %w[① ② ③ ④].freeze
  RAW_KEYS = %w[31-11 32-11 33-11 34-11 33-15 31-16 32-16 33-16 35-16
    32-17 34-16 35-17 31-18 33-17 35-18 32-18 33-18 34-18].freeze
  SOURCES = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_31_to_35_official_sources.json"))).freeze
  PDF_HASHES = {
    "guidance" => "d2ed3339c0e1098baa177ec0b1ebf435e344310daa4278a1fc3c601e2165e8a0",
    "curriculum" => "59ef17a825bd11a4fa39ed2cc1f27033c83a95e4e93f0f8a821a65e063bb2512",
    "information" => "0a95db55b9ec0570ac4b47586d9f6342c82a0ec5e7c0b071111208ae6e09d443",
    "report" => "5affb870ae87af1c6272b15b008fea88547ccc50141e20e38fd13bb128f9f39c",
  }.freeze

  setup do
    @questions = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
      .to_h { |entry| ["#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}", entry.fetch(:attributes)] }
  end

  test "原典は独立した四公式PDFから必要な連続範囲だけを抽出し頁と境界を記録する" do
    assert_equal (RAW_KEYS + %w[35-11 31-17 34-17]).sort, SOURCES.fetch("locations").keys.sort
    assert_equal 18, SOURCES.fetch("locations").values.count { |item| item.fetch("mode") == "raw_excerpt" }
    SOURCES.fetch("documents").each do |name, document|
      assert_equal PDF_HASHES.fetch(name), document.fetch("pdf_sha256"), name
      assert_match(/\Ahttps:\/\/www\.mext\.go\.jp\/content\//, document.fetch("url"), name)
    end
    fragments = SOURCES.fetch("fragments")
    assert_equal 23, fragments.values.map { |item| item.values_at("document", "pdf_page") }.uniq.size
    fragments.each do |name, item|
      assert SOURCES.fetch("documents").key?(item.fetch("document")), name
      assert_match(/\A[0-9a-f]{64}\z/, item.fetch("page_extract_sha256"), name)
      assert normalized(item.fetch("raw_text")).start_with?(normalized(item.fetch("start"))), name
      assert normalized(item.fetch("raw_text")).end_with?(normalized(item.fetch("end"))), name
      assert_operator item.fetch("pdf_page"), :>, item.fetch("printed_page"), name
      assert_equal 4, item.fetch("crop_bbox").size, name
    end
  end

  test "十八原文穴埋めは正答行だけが原典の連続した抜粋全体に一致する" do
    RAW_KEYS.each do |id|
      question = @questions.fetch(id)
      assert_includes question.fetch(:content_blocks).first.fetch(:text), "からの抜粋である。", id
      assert_equal "raw_excerpt", location(id).fetch("mode"), id
      assert quote(question).match?(/\{\{[^{}]+\}\}/), "#{id} 実空欄を全て除いたデータを許可しない"
      assert_unique_source_match(id, source(id))
    end
    # Both fragments meet at the physical page boundary. Footnote 7--9 and the
    # running header are outside these selected body ranges, not silently cut
    # from the middle of the quoted paragraph.
    assert fragment("g32a").end_with?("校外の教育委員会等（小")
    assert fragment("g32b").start_with?("中高等学校又は特別支援学校を設置する")
  end

  test "課題研究の二つの項番参照だけを独立した四指導項目名へ展開する" do
    id = "31-17"
    question = @questions.fetch(id)
    item = location(id)
    original = source(id)
    reference = normalized(fragment(item.fetch("reference_fragment_id")))
    names = ["調査，研究，実験", "作品制作", "産業現場等における実習", "職業資格の取得"]
    assert_equal normalized(names.each_with_index.map { |name, index| "（#{index + 1}）#{name}" }.join), reference.delete_prefix("〔指導項目〕")
    assert_equal 2, item.fetch("transformations").size
    expanded = item.fetch("transformations").reduce(original) do |text, transformation|
      before, after = transformation.values_at("from", "to").map { |value| normalized(value) }
      assert_equal 1, text.scan(Regexp.new(Regexp.escape(before))).size, before
      text.sub(before, after)
    end
    assert_unique_source_match(id, expanded)
    assert_includes question[:content_blocks].first[:text], "示された内容に基づく記述である。"
    assert_not_includes question[:content_blocks].first[:text], "からの抜粋"
    assert_not_includes quote(question), "〔指導項目〕"
    assert_not_includes quote(question), "（1）から（4）"
    assert_includes expanded, normalized("これら四つの指導項目の２項目以上")
  end

  test "図五の編集表は原図の一から五の対応と点検評価による終結継続を保持する" do
    id = "35-11"
    question = @questions.fetch(id)
    item = location(id)
    assert_equal source(id), normalized(quote(question))
    assert_not_includes quote(question), "アセスメント"
    table = question.fetch(:content_blocks).find { |block| block.fetch(:type) == "table" }
    assert table
    assert_equal ["段階", "チーム支援のプロセス"], table.fetch(:headers)
    assert_equal %w[1 2 3 4 5], table.fetch(:rows).map(&:first)
    assert_not table.fetch(:rows).flatten.any? { |cell| cell.include?("{{") }
    assert_equal %w[① ②], table.fetch(:rows).flatten.join.scan(/【([^】]+)】/).flatten
    assert_equal %w[① ②], question.fetch(:content_blocks).first.fetch(:text).scan(/\{\{([^{}]+)\}\}/).flatten
    figure = normalized(fragment(item.fetch("figure_fragment_id")))
    assert_includes figure, "図5チーム支援のプロセス"
    assert_includes figure, "困難課題対応的生徒指導及び課題早期発見対応の場合"
    steps = item.fetch("figure_steps")
    steps.each_value { |name| assert_includes figure, normalized(name) }
    question.fetch(:choices).each do |choice|
      replacements = BLANKS.zip(cells(choice)).to_h
      rows = table.fetch(:rows).to_h.transform_values do |value|
        value.gsub(/【([^】]+)】/) { replacements.fetch(Regexp.last_match(1)) }
      end
      assert_equal choice.fetch(:correct), rows == steps, choice.fetch(:label)
    end
    assert_includes normalized(fragment(item.fetch("assessment_fragment_id"))), normalized("情報を収集・分析・共有し、課題解決に有効な支援仮説を立て")
    evaluation = normalized(fragment(item.fetch("evaluation_fragment_id")))
    assert_includes evaluation, normalized("チーム支援計画の目標が達成されたと判断された場合は、チーム支援を終結します。")
    assert_includes evaluation, normalized("年度を越える場合は、再度新年度にケース会議を開催してアセスメントを行い")
    assert question.fetch(:content_blocks).any? { |block| block[:type] == "text" && block[:text].include?("原図そのものではない") }
  end

  test "個数問題は独立原典の科学的判断とCIA三要素と認証更新の根拠に対応する" do
    question = @questions.fetch("34-17")
    assert_equal %w[text fill_in_quote], question.fetch(:content_blocks).map { |block| block.fetch(:type) }
    laws = normalized(fragment("count_laws"))
    security = normalized(fragment("count_security"))
    updates = normalized(fragment("count_updates"))
    evidence = {
      "A" => "法規や制度が改正されたり，マナーが変わったりしても，科学的な根拠や，法規や制度及びマナーの意義に基づいて正しい対応ができるようにする。",
      "B" => "情報セキュリティの3要素である機密性・完全性・可用性の重要性",
      "C" => "推測されにくいパスワードや生体認証などの個人認証の必要性，ソフトウェアのセキュリティ更新プログラムを適用する必要性，その提供が終了したソフトウェアを使い続けることの危険性",
    }
    assert_includes laws, normalized(evidence.fetch("A"))
    assert_includes security, normalized(evidence.fetch("B"))
    assert_includes updates, normalized(evidence.fetch("C"))
    statements = quote(question).lines.map(&:strip).reject(&:empty?)
    assert_equal %w[A B C], statements.map { |line| line[/\A[A-C]/] }
    assert_includes normalized(statements[0]), normalized(evidence.fetch("A"))
    assert_includes normalized(statements[1]), normalized("機密性・真正性・可用性")
    assert_includes normalized(statements[1]), normalized("組織や個人が行うべき対策と技術的な対策との関係を理解する")
    assert_includes normalized(statements[2]), normalized(evidence.fetch("C"))
    assert_equal({ "A" => true, "B" => false, "C" => true }, location("34-17").fetch("statement_truth"))
    correct = question.fetch(:choices).find { |choice| choice.fetch(:correct) }
    assert_equal "2個", correct.fetch(:content_blocks).first.fetch(:text)
    assert_equal ["0個", "1個", "2個", "3個"], question.fetch(:choices).map { |choice| choice.fetch(:content_blocks).first.fetch(:text) }.sort
  end

  private

  def normalized(text)
    text.gsub(/[[:space:]　\u0007]+/, "")
  end

  def location(id)
    SOURCES.fetch("locations").fetch(id)
  end

  def fragment(id)
    SOURCES.fetch("fragments").fetch(id).fetch("raw_text")
  end

  def source(id)
    normalized(location(id).fetch("fragment_ids").map { |name| fragment(name) }.join("\n"))
  end

  def quote(question)
    question.fetch(:content_blocks).find { |block| block.fetch(:type) == "fill_in_quote" }.fetch(:text)
  end

  def cells(choice)
    choice.fetch(:content_blocks).first.fetch(:cells)
  end

  def restored(question, choice)
    replacements = BLANKS.zip(cells(choice)).to_h
    quote(question).gsub(/\{\{([^{}]+)\}\}/) { replacements.fetch(Regexp.last_match(1)) }
  end

  def assert_unique_source_match(id, original)
    question = @questions.fetch(id)
    matches = question.fetch(:choices).map do |choice|
      matched = original == normalized(restored(question, choice))
      assert_equal choice.fetch(:correct), matched, "#{id} #{choice.fetch(:label)}"
      matched
    end
    assert_equal 1, matches.count(true), id
  end
end
