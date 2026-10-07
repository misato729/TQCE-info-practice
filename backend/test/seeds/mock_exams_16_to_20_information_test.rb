require "test_helper"
require "uri"

class MockExams16To20InformationTest < ActiveSupport::TestCase
  EXAMS = (16..20).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  EXPANDED = %w[16-17 18-16 19-17].freeze
  EXPECTED_RANGES = { 16 => [1, 2, 3], 17 => [1, 3, 4], 18 => [2, 3, 4], 19 => [1, 2, 4], 20 => [1, 2, 3] }.freeze

  setup do
    entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @questions = entries.select { |entry| (16..18).cover?(entry.fetch(:attributes).fetch(:question_number)) }
      .to_h { |entry| ["#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}", entry.fetch(:attributes)] }
    @fixture = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_16_to_20_information_excerpts.json")))
  end

  test "五セット十五問は四範囲から異なる三範囲を資料及び項目順に出題する" do
    assert_equal 15, @questions.size
    assert_equal @fixture.fetch("locations").keys.sort, @questions.keys.sort
    EXAMS.each do |exam|
      ranges = (16..18).map { |number| source_range(prompt("#{exam}-#{number}")) }
      assert_equal EXPECTED_RANGES.fetch(exam), ranges
      assert_equal 3, ranges.uniq.size
      assert_equal ranges.sort, ranges
    end
    @questions.each_value do |question|
      assert_equal "information", question.fetch(:major_category_code)
      assert_includes %w[information_specialized information_education], question.fetch(:category_code)
    end
  end

  test "十四穴埋めと一個数問題は四択一正答及び全選択肢の解説を持つ" do
    assert_equal 14, @questions.values.count { |question| question.fetch(:content_blocks).first.fetch(:type) == "fill_in_text" }
    assert_equal ["18-18"], @questions.keys.select { |key| location(key).fetch("kind") == "correct_count" }
    @questions.each do |key, question|
      choices = question.fetch(:choices)
      assert_equal LABELS, choices.map { |choice| choice.fetch(:label) }, key
      assert_equal 1, choices.count { |choice| choice.fetch(:correct) }, key
      explanation = question.fetch(:explanation_blocks).filter_map { |block| block[:text] }.join("\n")
      LABELS.each { |label| assert_includes explanation, "#{label}：", key }
      next if location(key).fetch("kind") == "correct_count"

      assert_equal %w[fill_in_text fill_in_quote], question.fetch(:content_blocks).map { |block| block.fetch(:type) }, key
      blanks = quote(key).scan(/\{\{([①②③④])\}\}/).flatten.uniq.sort
      assert_includes [BLANKS.first(3), BLANKS], blanks, key
      assert_equal [blanks.first, blanks.last], prompt(key).scan(/\{\{([①②③④])\}\}/).flatten.uniq, key
      rows = choices.map do |choice|
        assert_equal 1, choice.fetch(:content_blocks).size, key
        assert_equal "fill_in_choice", choice.fetch(:content_blocks).first.fetch(:type), key
        values = cells(choice)
        assert_equal blanks.size, values.size, key
        values
      end
      assert_equal 4, rows.uniq.size, key
      rows.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort, key }
    end
  end

  test "十一原文抜粋は正答による全文復元だけが独立原典の連続本文に一致する" do
    originals = @questions.keys.select { |key| location(key).fetch("kind") == "verbatim" }
    assert_equal 11, originals.size
    originals.each do |key|
      assert_includes prompt(key), "からの抜粋である。"
      assert_not_includes prompt(key), "示された内容に基づく記述"
      original = normalize(source_body(key))
      @questions.fetch(key).fetch(:choices).each do |choice|
        restored = normalize(restore(key, choice))
        assert_equal choice.fetch(:correct), original.include?(restored), "#{key} #{choice.fetch(:label)}"
      end
    end
    assert_equal [194, 195], location("19-16").fetch("pdf_pages")
    assert_equal [196, 197], location("20-16").fetch("pdf_pages")
  end

  test "三展開型は項番を原典へ戻すと正答だけが連続原文に一致する" do
    assert_equal EXPANDED.sort, @questions.keys.select { |key| location(key).fetch("kind") == "expanded" }.sort
    EXPANDED.each do |key|
      assert_includes prompt(key), "に示された内容に基づく記述である。"
      assert_not_includes prompt(key), "からの抜粋である。"
      original = normalize(source_body(key))
      @questions.fetch(key).fetch(:choices).each do |choice|
        expanded = restore(key, choice)
        assert_not original.include?(normalize(expanded)), "#{key} 展開版を原文抜粋と混同しない"
        reverted = restore_references(key, expanded)
        assert_equal choice.fetch(:correct), original.include?(normalize(reverted)), "#{key} #{choice.fetch(:label)} 項番復元"
      end
    end
  end

  test "展開された具体的内容名は別頁の指導項目と番号及び記号まで対応する" do
    expected = {
      "16-17" => [
        "（1）情報社会と情報セキュリティア情報セキュリティの現状イ情報セキュリティの必要性",
        "（2）情報セキュリティと法規ア情報セキュリティ関連法規イ情報セキュリティ関連ガイドライン"
      ],
      "18-16" => [
        "（3）データとデータベースの操作アデータの操作イデータベースの定義ウデータベースの操作",
        "（4）データベースの運用と保守アデータベースの運用管理イデータベースの保守"
      ],
      "19-17" => [
        "（2）静止画のコンテンツア静止画による表現イ静止画の編集ウ静止画のコンテンツ制作",
        "（3）動画のコンテンツア動画による表現イ動画の編集ウ動画のコンテンツ制作",
        "（4）音・音声のコンテンツア音・音声による表現イ音・音声の編集ウ音・音声のコンテンツ制作"
      ]
    }
    expected.each do |key, sections|
      pages = location(key).fetch("reference_pages") + location(key).fetch("pdf_pages")
      body = pages.map { |page| @fixture.fetch("pages").fetch("curriculum").fetch(page.to_s).fetch("text") }.join("\n")
      items = normalize(body.split("〔指導項目〕\n", 2).last)
      sections.each { |section| assert_includes items, section, key }
      assert_equal({ "16-17" => [413], "18-16" => [417], "19-17" => [419] }.fetch(key), location(key).fetch("reference_pages"))
    end
  end

  test "情報デザインの三記述は独立原典の役割及びモデルと造形色彩の対応で判定する" do
    key = "18-18"
    blocks = @questions.fetch(key).fetch(:content_blocks)
    assert_equal %w[text text text text], blocks.map { |block| block.fetch(:type) }
    statements = blocks.drop(1).map { |block| normalize(block.fetch(:text)) }
    assert_equal BLANKS.first(3), statements.map { |statement| statement.first }
    evidence = @fixture.fetch("evidence").fetch(key)
    evidence.each_value do |record|
      page = @fixture.fetch("pages").fetch(record.fetch("source")).fetch(record.fetch("pdf_page").to_s)
      assert_equal page.fetch("printed_page"), record.fetch("printed_page")
      assert_includes page.fetch("text"), record.fetch("text")
    end
    first, second, third = BLANKS.first(3).map { |number| normalize(evidence.fetch(number).fetch("text")) }
    %w[インフォグラフィックス ピクトグラム 合目的性 ISO 人間中心設計].each do |concept|
      assert_includes first, concept
      assert_includes statements[0], concept
    end
    assert_includes first, "デザインを考えながら評価，改善を常に繰り返す"
    assert_includes statements[0], "評価・改善を繰り返す"
    assert_includes second, "外見的なデザインだけでなく，利用者の環境を含めたデザイン"
    assert_includes second, "シャノンとウィーバーのコミュニケーションモデル"
    assert_includes second, "コミュニケーションについての基本的なモデル"
    assert_includes second, "情報伝達やコミュニケーションの仕組みの捉え方"
    assert_includes statements[1], "人間中心設計のプロセスを示す基本モデル"
    assert_not_includes second, "人間中心設計"
    assert_includes third, "造形については，図と地の関係，錯視，ゲシュタルト要因"
    assert_includes third, "色彩については，暖色，寒色，膨張色，収縮色"
    assert_includes statements[2], "造形については暖色，寒色，膨張色，収縮色"
    assert_includes statements[2], "色彩については図と地の関係，錯視，ゲシュタルト要因"
    explanation = @questions.fetch(key).fetch(:explanation_blocks).map { |block| block.fetch(:text) }.join("\n")
    assert_includes explanation, "正しいのは①の1つ"
    assert_includes explanation, "人間中心設計の作業プロセスと同一ではない"
    assert_includes explanation, "対応が逆"
    choices = @questions.fetch(key).fetch(:choices)
    assert_equal [3, 2, 1, 0], choices.map { |choice| choice.fetch(:content_blocks).first.fetch(:text).to_i }
    assert_equal [false, false, true, false], choices.map { |choice| choice.fetch(:correct) }
  end

  test "繰り返す語句は同じ空欄で伏せ原文の列挙番号とは区別する" do
    { "18-17" => ["①", 2], "18-16" => ["③", 2], "20-17" => ["①", 2] }.each do |key, (number, count)|
      assert_equal count, quote(key).scan("{{#{number}}}").size, key
      assert_not_includes quote(key), cells(correct_choice(key)).fetch(BLANKS.index(number)), key
    end
    @questions.each do |key, question|
      next if location(key).fetch("kind") == "correct_count"

      cells(correct_choice(key)).each { |cell| assert_not_includes quote(key), cell, key }
      assert_not quote(key).match?(/【[①②③④]】/), key
    end
    assert_includes quote("17-18"), "①"
    assert_includes quote("17-18"), "②"
    assert_includes quote("17-18"), "③"
    assert_includes quote("17-18"), "{{①}}"
  end

  test "全出典は公式PDFとビューア頁及び印刷頁が独立fixtureと一致する" do
    @questions.each do |key, question|
      loc = location(key)
      document = @fixture.fetch("source_documents").fetch(loc.fetch("source"))
      assert_match(/\A[0-9a-f]{64}\z/, document.fetch("sha256"))
      lines = question.fetch(:source_text).lines.map(&:strip)
      assert_equal 1, lines.size, key
      title, link = lines.first.split(" | ", 2)
      assert title.present?, key
      uri = URI.parse(link)
      assert_equal "https", uri.scheme, key
      assert_equal "www.mext.go.jp", uri.host, key
      assert_equal URI.parse(document.fetch("url")).path, uri.path, key
      assert_equal "page=#{loc.fetch("pdf_pages").first}", uri.fragment, key
      first_page = @fixture.fetch("pages").fetch(loc.fetch("source")).fetch(loc.fetch("pdf_pages").first.to_s)
      assert_match(/#{first_page.fetch("printed_page")}(?:頁|〜)/, title, key)
      assert_match(/PDF#{loc.fetch("pdf_pages").first}(?:頁|〜)/, title, key)
      assert_equal (loc.fetch("source") == "commentary"), prompt(key).include?("解説 情報編"), key
    end
  end

  private

  def location(key)
    @fixture.fetch("locations").fetch(key)
  end

  def prompt(key)
    @questions.fetch(key).fetch(:content_blocks).first.fetch(:text)
  end

  def quote(key)
    @questions.fetch(key).fetch(:content_blocks).find { |block| block.fetch(:type) == "fill_in_quote" }.fetch(:text)
  end

  def cells(choice)
    choice.fetch(:content_blocks).first.fetch(:cells)
  end

  def correct_choice(key)
    @questions.fetch(key).fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def normalize(text)
    text.gsub(/[[:space:]\x00-\x1f]+/, "")
  end

  def source_body(key)
    loc = location(key)
    loc.fetch("pdf_pages").map { |page| @fixture.fetch("pages").fetch(loc.fetch("source")).fetch(page.to_s).fetch("text") }.join("\n")
  end

  def source_range(text)
    case text
    when /第2章 第10節/ then 1
    when /第3章 第7節/ then 2
    when /第1部 各学科に共通する教科/ then 3
    when /第2部 主として専門学科において開設される教科/ then 4
    else flunk "出典範囲を特定できない: #{text}"
    end
  end

  def restore(key, choice)
    values = cells(choice)
    quote(key).gsub(/\{\{([①②③④])\}\}/) { values.fetch(BLANKS.index(Regexp.last_match(1))) }
  end

  def restore_references(key, text)
    replacements = case key
    when "16-17"
      {
        "「情報社会と情報セキュリティ」の「情報セキュリティの現状」については" => "ア 〔指導項目〕の（1）のアについては",
        "「情報セキュリティの必要性」については" => "イについては",
        "「情報セキュリティと法規」の「情報セキュリティ関連法規」については" => "イ 〔指導項目〕の（2）のアについては",
        "「情報セキュリティ関連ガイドライン」については" => "イについては"
      }
    when "18-16"
      {
        "「データとデータベースの操作」の「データの操作」については" => "ウ 〔指導項目〕の（3）のアについては",
        "「データベースの定義」については" => "イについては",
        "「データベースの操作」については" => "ウについては",
        "「データベースの運用と保守」の「データベースの運用管理」については" => "エ 〔指導項目〕の（4）のアについては",
        "「データベースの保守」については" => "イについては"
      }
    when "19-17"
      { "「静止画のコンテンツ」，「動画のコンテンツ」及び「音・音声のコンテンツ」" => "〔指導項目〕の（2）から（4）まで" }
    else raise "展開型ではない: #{key}"
    end
    replacements.reduce(text) { |result, (expanded, reference)| result.gsub(expanded, reference) }
  end
end
