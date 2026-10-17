require "test_helper"
require "digest"

class MockExams36To40CompletionSourcesTest < ActiveSupport::TestCase
  EXAMS = (36..40).to_a.freeze
  BLANKS = %w[① ② ③ ④].freeze
  RAW_KEYS = %w[36-11 37-11 38-11 39-11 38-15 36-16 37-16 38-16 40-16
    36-17 37-17 39-16 40-17 36-18 38-17 40-18 37-18 38-18 39-18].freeze
  SOURCES = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_36_to_40_completion_sources.json"))).freeze
  PDF_HASHES = {
    "guidance" => "d2ed3339c0e1098baa177ec0b1ebf435e344310daa4278a1fc3c601e2165e8a0",
    "report" => "5affb870ae87af1c6272b15b008fea88547ccc50141e20e38fd13bb128f9f39c",
    "curriculum" => "59ef17a825bd11a4fa39ed2cc1f27033c83a95e4e93f0f8a821a65e063bb2512",
    "information" => "0a95db55b9ec0570ac4b47586d9f6342c82a0ec5e7c0b071111208ae6e09d443",
  }.freeze

  setup do
    @questions = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
      .select { |entry| SOURCES.fetch("locations").key?("#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}") }
      .to_h { |entry| ["#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}", entry.fetch(:attributes)] }
  end

  test "二十問の照合元を四公式PDFの独立抽出頁と座標及び固定ハッシュで記録する" do
    assert_equal (RAW_KEYS + ["40-11"]).sort, SOURCES.fetch("locations").keys.sort
    assert_equal SOURCES.fetch("locations").keys.sort, @questions.keys.sort
    assert_equal 19, SOURCES.fetch("locations").values.count { |item| item.fetch("mode") == "raw_excerpt" }
    assert_equal 25, SOURCES.fetch("documents").values.sum { |document| document.fetch("pages").size }
    SOURCES.fetch("documents").each do |name, document|
      assert_equal PDF_HASHES.fetch(name), document.fetch("pdf_sha256"), name
      assert_match(/\Ahttps:\/\/www\.mext\.go\.jp\/content\//, document.fetch("url"), name)
      document.fetch("pages").each do |pdf_page, page|
        assert_equal Digest::SHA256.hexdigest(page.fetch("raw_text")), page.fetch("extract_sha256"), "#{name} #{pdf_page}"
        assert_equal 4, page.fetch("crop_bbox").size
        assert_operator pdf_page.to_i, :>, page.fetch("printed_page")
        assert page.fetch("display_exclusions").present?
      end
    end
    @questions.each do |id, question|
      document = SOURCES.fetch("documents").fetch(location(id).fetch("document"))
      first_page = location(id).fetch("pdf_pages").first
      assert_includes question.fetch(:source_text), "#{document.fetch('url')}#page=#{first_page}", id
    end
  end

  test "十九原文穴埋めは正答行だけが独立原典の連続本文全体に一致する" do
    RAW_KEYS.each do |id|
      question = @questions.fetch(id)
      assert_includes question.fetch(:content_blocks).first.fetch(:text), "からの抜粋である。", id
      assert quote(question).match?(/\{\{[^{}]+\}\}/), "#{id} 実空欄を全て除いたデータを許可しない"
      assert_unique_source_match(id, source(id))
    end
    # These quotations continue at the actual PDF page boundary, not at a
    # sentence assembled from disconnected source passages. Only running
    # headers, side labels and printed page numbers fall outside the crop.
    assert page("curriculum", 193).end_with?("理解し")
    assert page("curriculum", 194).start_with?("技能を身に付けること。")
    assert page("curriculum", 415).end_with?("うにする。")
    assert page("curriculum", 416).start_with?("（2）ネットワークシステム")
    assert page("information", 104).end_with?("改善するこ")
    assert page("information", 105).start_with?("とができるような指導")
    assert page("report", 28).end_with?("ため，子")
    assert page("report", 29).start_with?("供たちの基礎学力")
  end

  test "コミュニティスクールの本文と脚注十六を分離して同じ承認空欄を復元する" do
    id = "39-11"
    question = @questions.fetch(id)
    original = page("guidance", location(id).fetch("footnote_page"))
    footnote = original.match(/\[\*16\]\s*(学校運営協議会の主な役割として、.*)\z/m)&.captures&.first
    assert footnote
    body, _ = original.split(/\[\*16\]\s*学校運営協議会の主な役割として、/, 2)
    assert_unique_source_match(id, normalized(body))
    note = question.fetch(:content_blocks).find { |block| block[:text].to_s.start_with?("原文の脚注[*16]") }
    assert note
    assert_equal "fill_in_text", note.fetch(:type)
    actual_note = note.fetch(:text).split("：", 2).last
    assert_equal 1, actual_note.scan("{{②}}").size
    assert_equal 1, quote(question).scan("{{②}}").size
    assert_includes quote(question), "{{①}}[*16]"
    assert_includes actual_note, "①校長が作成する学校運営の基本方針を{{②}}する"
    assert_includes actual_note, "②学校運営に関する意見"
    assert_includes actual_note, "③教職員の任用"
    question.fetch(:choices).each do |choice|
      match = normalized(footnote) == normalized(restore(actual_note, choice))
      assert_equal cells(choice).fetch(1) == "承認", match, "#{id} 脚注 #{choice.fetch(:label)}"
    end
  end

  test "図六の編集表は三つの支援チームと外側の管理職によるマネジメントを保つ" do
    id = "40-11"
    question = @questions.fetch(id)
    assert_includes source(id), normalized(quote(question))
    assert_not quote(question).match?(/\{\{[^{}]+\}\}/)
    figure = normalized(page("guidance", location(id).fetch("figure_page")))
    assert_includes figure, "図6支援チームの形態"
    expected = location(id).fetch("figure_rows")
    expected.each do |label, value|
      assert_includes figure, normalized(value), label
      assert_includes figure, normalized(label + value), label unless label == "三つの形態を包む外側の枠"
    end
    table = question.fetch(:content_blocks).find { |block| block[:type] == "table" }
    assert table
    assert_equal ["図に示された形態・範囲", "連携・協働又はマネジメントの仕組み"], table.fetch(:headers)
    assert_equal expected.keys, table.fetch(:rows).map(&:first)
    assert_equal %w[① ②], table.fetch(:rows).flatten.join.scan(/【([^】]+)】/).flatten
    assert_not table.fetch(:rows).flatten.any? { |cell| cell.include?("{{") }
    assert_equal %w[① ②], question.fetch(:content_blocks).first.fetch(:text).scan(/\{\{([^{}]+)\}\}/).flatten
    question.fetch(:choices).each do |choice|
      actual = table.fetch(:rows).to_h.transform_values { |value| restore(value, choice, table: true) }
      assert_equal choice.fetch(:correct), actual == expected, "#{id} #{choice.fetch(:label)}"
    end
    assert question.fetch(:content_blocks).any? { |block| block[:type] == "text" && block[:text].include?("原図そのものではない") }
  end

  test "プログラム作成の抜粋前の注を情報システムの分割の原典に結び付ける" do
    question = @questions.fetch("37-18")
    note = question.fetch(:content_blocks).find { |block| block[:text].to_s.start_with?("注：ここでいう「分割した機能要素」") }
    assert note
    assert_equal "text", note.fetch(:type)
    assert_includes note.fetch(:text), "情報システムを入力，出力，通信などの機能要素に分割したもの"
    assert_includes normalized(page("information", 130)), normalized("入力，出力，通信などの機能要素間でやり取りされるデータを記述することで情報システムを分割することができること")
    assert_includes question.fetch(:source_text), "https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=130"
  end

  private

  def normalized(text)
    text.unicode_normalize(:nfkc).gsub(/[[:space:]\u0000-\u001f\u007f]+/, "")
  end

  def location(id) = SOURCES.fetch("locations").fetch(id)
  def page(document, number) = SOURCES.fetch("documents").fetch(document).fetch("pages").fetch(number.to_s).fetch("raw_text")
  def source(id) = normalized(location(id).fetch("pdf_pages").map { |number| page(location(id).fetch("document"), number) }.join("\n"))
  def quote(question) = question.fetch(:content_blocks).find { |block| block.fetch(:type) == "fill_in_quote" }.fetch(:text)
  def cells(choice) = choice.fetch(:content_blocks).first.fetch(:cells)

  def restore(text, choice, table: false)
    replacements = BLANKS.zip(cells(choice)).to_h
    pattern = table ? /【([^】]+)】/ : /\{\{([^{}]+)\}\}/
    text.gsub(pattern) { replacements.fetch(Regexp.last_match(1)) }
  end

  def assert_unique_source_match(id, original)
    question = @questions.fetch(id)
    matches = question.fetch(:choices).map do |choice|
      match = original.include?(normalized(restore(quote(question), choice)))
      assert_equal choice.fetch(:correct), match, "#{id} #{choice.fetch(:label)}"
      match
    end
    assert_equal 1, matches.count(true), id
  end
end
