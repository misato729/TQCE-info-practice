require "test_helper"

class MockExamsSelfContainedTextTest < ActionDispatch::IntegrationTest
  EXPECTED_ANSWERS = {
    "1-6" => "ウ",
    "2-6" => "ア",
    "2-7" => "ウ",
    "2-10" => "エ",
    "2-18" => "ウ",
    "3-10" => "ウ",
    "3-11" => "エ",
    "4-11" => "エ",
    "5-10" => "イ",
    "5-11" => "ア",
    "5-18" => "エ",
    "6-6" => "ウ",
    "6-8" => "エ",
    "7-9" => "エ",
    "9-9" => "ア",
    "12-7" => "ウ",
    "16-6" => "エ",
    "17-6" => "ウ",
  }.freeze
  ADAPTED = %w[2-10 3-10 3-11 4-11 5-10 5-18 6-6 7-9 12-7 16-6].freeze
  ORIGINALS = JSON.parse(File.read(Rails.root.join("test/fixtures/self_contained_official_excerpts.json"))).fetch("excerpts").freeze

  setup do
    entries = QuestionSeedSync.collect do
      (1..20).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @entries = entries.select { |entry| EXPECTED_ANSWERS.key?(key_for(entry)) }
    @questions = @entries.to_h { |entry| [key_for(entry), entry.fetch(:attributes)] }
  end

  test "対象十八問だけを検査し既存の四択一正答と正答位置を保つ" do
    assert_equal EXPECTED_ANSWERS.keys.sort, @questions.keys.sort
    @questions.each do |key, question|
      choices = question.fetch(:choices)
      assert_equal %w[ア イ ウ エ], choices.map { |choice| choice.fetch(:label) }, key
      assert_equal 1, choices.count { |choice| choice.fetch(:correct) }, key
      assert_equal EXPECTED_ANSWERS.fetch(key), choices.find { |choice| choice.fetch(:correct) }.fetch(:label), key
      assert_equal 4, choices.map { |choice| choice.fetch(:content_blocks) }.uniq.size, key
      question.fetch(:source_text).lines.each { |line| assert_match(/\A.+ \| https:\/\/\S+\z/, line.strip, key) }
      assert_not question.fetch(:content_blocks).any? { |block| block[:type] == "quote" }, key
    end
  end

  test "未提示の項番と図への参照を本文と選択肢に残さず指示語から始めない" do
    @questions.each do |key, question|
      body = quote(key)
      assert_no_match(/\A(?:その中で|その際|このことは|高等学校においてこのような)/, body, key)
      # 範囲名・出典の照合用項番ではなく、解答時に読む本文と選択肢を検査する。
      choice_text = question.fetch(:choices).flat_map { |choice| choice.fetch(:content_blocks).filter_map { |block| block[:text] } }.join("\n")
      assert_no_match(/第[１1２2]款の[２2３3]の|第[１1]の目標|（[１２３４５６123456]）に示す|（2）から（4）|図[１２12]|→1\.2\.|第[６6]章に示す/, body + choice_text, key)
    end
    assert_includes quote("2-7"), "キャリア教育の充実を図ること。その中で"
    assert_includes quote("9-9"), "道徳教育の全体計画の作成に当たっては"
    assert_includes @questions.fetch("9-9").fetch(:source_text), "第7款1後段"
    %w[ア ウ].each do |label|
      text = @questions.fetch("2-18").fetch(:choices).find { |choice| choice.fetch(:label) == label }.fetch(:content_blocks).first.fetch(:text)
      %w[コミュニケーションと情報デザイン コンピュータとプログラミング 情報通信ネットワークとデータの活用].each { |topic| assert_includes text, topic }
    end
  end

  test "原文の連続した七抜粋は正答だけが独立した公式原典に一致する" do
    assert_equal 7, ORIGINALS.size
    ORIGINALS.each do |key, original|
      assert_includes prompt(key), "からの抜粋である。", key
      assert_not_includes prompt(key), "示された内容に基づく記述", key
      @questions.fetch(key).fetch(:choices).each do |choice|
        assert_equal choice.fetch(:correct), normalized(restore(key, choice)) == normalized(original), "#{key} #{choice.fetch(:label)}"
      end
    end
  end

  test "参照先を展開または図への文言を除いた十問は原文抜粋と誤表示しない" do
    @questions.each_key do |key|
      assert_equal ADAPTED.include?(key), prompt(key).include?("示された内容に基づく記述"), key
      assert_not_includes prompt(key), "からの抜粋である。", key if ADAPTED.include?(key)
    end
    %w[知識及び技能 思考力 学びに向かう力].each { |term| assert_includes quote("6-6"), term }
    assert_includes quote("7-9"), "基盤となる道徳性を養うという"
    assert_includes quote("12-7"), "障害による学習上又は生活上の困難を主体的に改善・克服"
    assert_includes @questions.fetch("12-7").fetch(:source_text), "特別支援学校高等部学習指導要領"
    %w[2-10 3-10 5-10].each do |key|
      %w[集団活動に必要な知識・技能 生活上の課題を解決する力 自己実現を図ろうとする態度].each { |term| assert_includes quote(key), term }
    end
  end

  test "文脈を補った後も空欄とセルの対応を保ち答えを本文へ露出しない" do
    @questions.except("2-18", "3-11").each do |key, question|
      labels = quote(key).scan(/\{\{([①②③④])\}\}/).flatten.uniq
      assert_includes(key == "5-11" ? [2] : [3, 4], labels.size, key)
      assert_equal %w[① ② ③ ④].first(labels.size), labels, key
      assert_equal [labels.first, labels.last], prompt(key).scan(/\{\{([①②③④])\}\}/).flatten.uniq, key
      question.fetch(:choices).each do |choice|
        assert_equal "fill_in_choice", choice.fetch(:content_blocks).first.fetch(:type), key
        assert_equal labels.size, choice.fetch(:content_blocks).first.fetch(:cells).size, key
      end
      answer = question.fetch(:choices).find { |choice| choice.fetch(:correct) }
      answer.fetch(:content_blocks).first.fetch(:cells).each { |cell| assert_not_includes quote(key), cell, key }
    end
    assert_equal 3, quote("12-7").scan("{{②}}").size
    assert_equal %w[fill_in_text fill_in_quote], @questions.fetch("16-6").fetch(:content_blocks).map { |block| block.fetch(:type) }
  end

  test "生徒指導の図に頼らず表の対象と時間軸及び両分類を読み取れる" do
    question = @questions.fetch("3-11")
    table = question.fetch(:content_blocks).find { |block| block[:type] == "table" }
    assert_equal ["生徒指導の層", "主な対象", "時間軸"], table.fetch(:headers)
    assert_equal ["【①】", "【②】"], table.fetch(:rows).flatten.grep(/【[①②]】/)
    assert_not_includes table.fetch(:rows).flatten.join, "{{"
    assert_includes prompt("3-11"), "表は，同資料に示された各層の対象と時間軸を整理"
    assert_includes quote("3-11"), "四つの層"
    assert_includes quote("4-11"), "一方，課題早期発見対応と困難課題対応的生徒指導"
    %w[3-11 4-11 5-11].each { |key| assert_operator quote(key).length, :>=, 140, key }
  end

  test "十八問は通常の取得と回答APIで表示し回答前は正答や解説を公開しない" do
    @entries.each { |entry| QuestionSeedSync.call(**entry) }
    headers = paid_user_headers("self-contained-check@example.com")
    @questions.each do |key, expected|
      exam, number = key.split("-").map(&:to_i)
      get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: number - 1 }, headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal exam, data.fetch("exam_number"), key
      assert_equal number, data.fetch("question_number"), key
      assert_equal expected.fetch(:content_blocks).as_json, data.fetch("content_blocks"), key
      assert_not data.key?("explanation_blocks"), key
      data.fetch("choices").each { |choice| assert_not choice.key?("is_correct"), key }
      question = Question.find_by!(exam_number: exam, question_number: number)
      answer = question.question_choices.find_by!(is_correct: true)
      post answer_api_v1_question_path(question), params: { selected_choice_id: answer.id }, headers: headers, as: :json
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct"), key
      assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks"), key
    end
  end

  private

  def paid_user_headers(email)
    user = User.create!(name: "自己完結性検証", email: email, password: "password123", password_confirmation: "password123")
    payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    Membership.create!(user: user, source_payment: payment, status: "active", activated_at: Time.current)
    { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
  end

  def key_for(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def prompt(key)
    @questions.fetch(key).fetch(:content_blocks).first.fetch(:text)
  end

  def quote(key)
    @questions.fetch(key).fetch(:content_blocks).find { |block| block[:type] == "fill_in_quote" }&.fetch(:text).to_s
  end

  def restore(key, choice)
    labels = quote(key).scan(/\{\{([①②③④])\}\}/).flatten.uniq
    cells = choice.fetch(:content_blocks).first.fetch(:cells)
    quote(key).gsub(/\{\{([①②③④])\}\}/) { cells.fetch(labels.index(Regexp.last_match(1))) }
  end

  def normalized(text)
    text.gsub(/[\s　\u0007]/, "")
  end
end
