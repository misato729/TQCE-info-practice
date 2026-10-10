require "test_helper"

class MockExamsQuestion19RevisionTest < ActionDispatch::IntegrationTest
  ANSWERS = { 2 => "イ", 4 => "ウ", 5 => "ウ", 6 => "イ", 9 => "ア", 10 => "ア", 14 => "エ" }.freeze
  LABELS = %w[ア イ ウ エ].freeze

  setup do
    @entries = QuestionSeedSync.collect do
      (1..20).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @targets = @entries.select do |entry|
      ANSWERS.key?(entry[:exam_number]) && entry[:attributes][:question_number] == 19
    end
    @questions = @targets.to_h { |entry| [entry[:exam_number], entry[:attributes]] }
  end

  test "七問は従来の正答位置と四択一正答を保ち全選択肢の解説と日本語出典を持つ" do
    assert_equal ANSWERS.keys, @questions.keys
    @entries.group_by { |entry| entry[:exam_number] }.each do |exam, entries|
      assert_equal (1..20).to_a, entries.map { |entry| entry[:attributes][:question_number] }
      answers = entries.map { |entry| entry[:attributes][:choices].find { |choice| choice[:correct] }[:label] }
      assert_equal LABELS.to_h { |label| [label, 5] }, answers.tally, "模試#{exam}"
    end
    @questions.each do |exam, question|
      assert_equal "information_specialized", question[:category_code]
      assert_equal LABELS, question[:choices].map { |choice| choice[:label] }
      assert_equal 1, question[:choices].count { |choice| choice[:correct] }
      assert_equal ANSWERS[exam], question[:choices].find { |choice| choice[:correct] }[:label]
      assert_equal 1, question[:content_blocks].count { |block| block[:type] == "code" }
      assert_operator program(exam).size, :<=, 16
      question[:choices].each { |choice| assert choice_explanation(exam, choice[:label]).present? }
      question[:source_text].lines.each { |line| assert_match(/\A.+ \| https:\/\/www\.mext\.go\.jp\/.+\z/, line.strip) }
      next unless [2, 9, 14].include?(exam)

      assert_equal %w[① ②], code(exam).scan(/【([①②])】/).flatten.uniq
      question[:choices].each { |choice| assert_equal 2, cells(choice).size }
      question[:choices].map { |choice| cells(choice) }.transpose.each do |column|
        assert_equal [2, 2], column.tally.values.sort
      end
      assert_equal %w[① ②], question[:content_blocks].first[:text].scan(/\{\{([①②])\}\}/).flatten
    end
    assert_not_includes code(14), "Buf"
    assert_not_includes code(14), "%"
    assert_not_includes @questions[6][:content_blocks].first[:text], "最大実行回数"
  end

  test "残高の更新と最大値の保存を全候補で実行し解説の値を照合する" do
    lines = program(2)
    assert_equal "    balance = 【①】", lines[4]
    assert_equal "        peak = 【②】", lines[6]
    data = array_assignment(lines[0])
    expected = ([0] + data.each_index.map { |i| data.first(i + 1).sum }).max
    @questions[2][:choices].each do |choice|
      source = filled_program(2, choice)
      source.insert(-2, "    record_row(change, balance, peak)")
      result = execute(source)
      assert_equal choice[:correct], result[:outputs] == [expected]
      if choice[:correct]
        assert_equal table_rows(2), string_rows(result[:rows])
      else
        assert_equal described_output(2, choice[:label]), result[:outputs].last
      end
      next unless choice[:label] == "ア"

      described = choice_explanation(2, "ア")[/peak は(.+?)と推移/, 1].split("，").map(&:to_i)
      assert_equal described, result[:rows].map(&:last)
    end
  end

  test "探索の終了位置を各修正候補と該当なしの場合で実行する" do
    lines = program(4)
    assert_equal "    break", lines[6]
    data = array_assignment(lines[0])
    limit = lines[1].split(" = ").last.to_i
    expected = data.index { |value| value >= limit }
    assert_equal [-1], execute(lines)[:outputs]
    @questions[4][:choices].each do |choice|
      source = lines.dup
      description = choice[:content_blocks].first[:text]
      case description
      when /06行より先/
        source.delete_at(6)
        source.insert(5, "        break")
      when /break を削除/
        source.delete_at(6)
      when /一段深く/
        source[6] = "        break"
      when /pos = 0/
        source[2] = "pos = 0"
      else
        flunk "未検証の修正候補"
      end
      output = execute(source)[:outputs]
      assert_equal choice[:correct], output == [expected]
      if choice[:correct]
        source[1] = "limit = #{data.max + 1}"
        assert_equal [-1], execute(source)[:outputs]
        rows = data.first(expected + 1).each_with_index.map do |value, i|
          [i, value, i == expected ? "成立・反復終了" : "不成立", i == expected ? i : -1]
        end
        assert_equal table_rows(4), string_rows(rows)
      else
        assert_equal described_output(4, choice[:label]), output.last
      end
    end
  end

  test "分割処理は基準値の位置だけを問い条件付きの更新回数と一致する" do
    lines = program(5)
    assert_equal "        a[i] と a[j] を交換する", lines[5]
    assert_equal "        i = i + 1", lines[6]
    assert_equal "a[i] と a[6] を交換する", lines[7]
    data = array_assignment(lines[0])
    expected = data[0...-1].count { |value| value <= data.last }
    source = lines.dup
    source.insert(4, "    inspected = a[j]")
    source.insert(-3, '    record_row(j, inspected, inspected <= pivot ? "成立" : "不成立", i)')
    result = execute(source)
    assert_equal [expected], result[:outputs]
    assert_equal table_rows(5), string_rows(result[:rows])
    @questions[5][:choices].each do |choice|
      assert_equal choice[:correct], choice[:content_blocks].first[:text].to_i == expected
    end
    assert_equal data.last, result[:state][:a][expected]
    assert_not_includes code(5), "swaps"
  end

  test "固定配列の二分探索を実行し正答と全途中経過を照合する" do
    lines = program(6)
    assert_includes lines, "  mid = (left + right) // 2"
    assert_includes lines, "    left = mid + 1"
    assert_includes lines, "    right = mid"
    source = lines.dup
    source.insert(6, "  old_left = left", "  old_right = right")
    source.insert(-2, "  record_row(old_left, old_right, mid, a[mid], left, right)")
    result = execute(source)
    actual = result[:state].values_at(:position, :count)
    data = array_assignment(lines[0])
    assert_equal data.index { |value| value >= result[:state][:target] }, actual.first
    @questions[6][:choices].each do |choice|
      candidate = choice[:content_blocks].first[:text].scan(/(?:position|count)：(\d+)/).flatten.map(&:to_i)
      assert_equal choice[:correct], candidate == actual
    end
    described = @questions[6][:explanation_blocks].find { |block| block[:type] == "code" }[:code]
    described_rows = described.lines.map do |line|
      values = line.scan(/(?:left|right|mid|a\[mid\])=(\d+)/).flatten.map(&:to_i)
      first_left, first_right, mid, value, changed = values
      after = line.include?("→ right=") ? [first_left, changed] : [changed, first_right]
      [first_left, first_right, mid, value, *after]
    end
    assert_equal described_rows, result[:rows]
  end

  test "範囲の両端と位置更新を全候補で実行し成功失敗の状態を照合する" do
    lines = program(9)
    assert_equal "    candidate = pos + step", lines[3]
    assert_equal "    if 【①】:", lines[4]
    data = array_assignment(lines[0])
    expected = data.reduce(2) { |pos, step| (0..6).cover?(pos + step) ? pos + step : pos }
    @questions[9][:choices].each do |choice|
      source = filled_program(9, choice)
      source.insert(3, "    before = pos")
      source.insert(-2, "    record_row(step, before, candidate, pos)")
      result = execute(source)
      assert_equal choice[:correct], result[:outputs] == [expected]
      if choice[:correct]
        rows = result[:rows].map do |step, before, candidate, pos|
          [step, before, candidate, (0..6).cover?(candidate) ? "移動する" : "移動しない", pos]
        end
        assert_equal table_rows(9), string_rows(rows)
      else
        assert_equal described_output(9, choice[:label]), result[:outputs].last
      end
      next unless choice[:label] == "イ"

      described = choice_explanation(9, "イ")[/位置は(.+?)と推移/, 1].split("，").map(&:to_i)
      assert_equal described, result[:rows].map(&:last)
    end
  end

  test "関数のreturn位置を各修正候補で実行し呼出しごとの合計を照合する" do
    lines = program(10)
    assert_equal "        return total", lines[4]
    expected = array_assignment(lines[5]).sum + array_assignment(lines[6]).sum
    assert_equal [6], execute(lines)[:outputs]
    @questions[10][:choices].each do |choice|
      source = lines.dup
      description = choice[:content_blocks].first[:text]
      case description
      when /一段浅く/
        source[4] = "    return total"
      when /03行の直前/
        source.delete_at(4)
        source.insert(2, "    return total")
      when /02行を04行の直前/
        source.delete_at(1)
        source.insert(2, "        total = 0")
      when /total = value/
        source[3] = "        total = value"
      else
        flunk "未検証の修正候補"
      end
      update = source.index { |line| line.strip.match?(/\Atotal = (?!0)/) }
      source.insert(update + 1, "        record_row(value, total)")
      result = execute(source)
      assert_equal choice[:correct], result[:outputs] == [expected]
      if choice[:correct]
        assert_equal [[2, 2], [5, 7], [1, 8], [4, 4], [3, 7]], result[:rows]
        rows = [["sum_values(a)", "2，5，1", "2 → 7 → 8", "8"], ["sum_values(b)", "4，3", "4 → 7", "7"]]
        assert_equal table_rows(10), rows
      else
        assert_equal described_output(10, choice[:label]), result[:outputs].last
      end
    end
  end

  test "直近三個の合計を全候補で実行し解説の配列と更新値を照合する" do
    lines = program(14)
    assert_equal "    s = s - Data[【①】]", lines[4]
    assert_equal "    s = s + Data[【②】]", lines[5]
    data = array_assignment(lines[0])
    expected = data.each_cons(3).map(&:sum)
    @questions[14][:choices].each do |choice|
      remove, add = cells(choice)
      source = filled_program(14, choice)
      source.insert(-2, "    record_row(i, Data[#{remove}], Data[#{add}], s)")
      result = execute(source)
      output = result[:outputs].last
      assert_equal choice[:correct], output == expected
      if choice[:correct]
        assert_equal table_rows(14), string_rows(result[:rows])
      else
        described = choice_explanation(14, choice[:label])[/出力は［(.+?)］/, 1].split("，").map(&:to_i)
        assert_equal described, output
      end
    end
  end

  test "七問をAPIで取得し全候補の採点と回答前後の公開範囲を検査する" do
    synchronize
    admin = User.create!(name: "問19検証", email: "q19-revision@example.com", password: "password123", password_confirmation: "password123", role: "admin")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    Question.where(exam_number: ANSWERS.keys, question_number: 19).each do |question|
      get next_api_v1_questions_path, params: { exam_number: question.exam_number, after_question_number: 18 }, headers: headers
      assert_response :success
      assert_equal question.content_blocks, response.parsed_body.fetch("data").fetch("content_blocks")
      get api_v1_question_path(question), headers: headers
      assert_response :success
      body = response.parsed_body.fetch("data")
      %w[correct_choice explanation_blocks source_text].each { |key| assert_not body.key?(key) }
      assert_equal 4, body.fetch("choices").size
      question.question_choices.each do |choice|
        post answer_api_v1_question_path(question), params: { selected_choice_id: choice.id }, headers: headers, as: :json
        assert_response :success
        answer = response.parsed_body.fetch("data")
        assert_equal choice.is_correct?, answer.fetch("is_correct")
        assert_equal question.explanation_blocks, answer.fetch("explanation_blocks")
        assert_equal question.source_text, answer.fetch("source_text")
      end
    end
  end

  test "変更のないseed再実行はIDと回答履歴と件数を保持する" do
    synchronize
    questions = Question.where(exam_number: ANSWERS.keys, question_number: 19)
    question = questions.first
    user = User.create!(name: "再実行検証", email: "q19-repeat@example.com", password: "password123", password_confirmation: "password123")
    history = user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
    ids = questions.order(:id).pluck(:id)
    choice_ids = QuestionChoice.where(question_id: ids).order(:id).pluck(:id)
    2.times do
      assert_no_difference(["Question.count", "QuestionChoice.count", "AnswerHistory.count"]) { synchronize }
      assert_equal ids, questions.order(:id).pluck(:id)
      assert_equal choice_ids, QuestionChoice.where(question_id: ids).order(:id).pluck(:id)
      assert AnswerHistory.exists?(history.id)
    end
  end

  test "seed全体の検査はコード穴埋めを許容し番号の欠落とセル数不一致を拒否する" do
    with_seed_entries(@entries) { load Rails.root.join("db/seeds.rb") }
    ["code", "prompt", "cells"].each do |part|
      entries = @entries.deep_dup
      question = entries.find { |entry| entry[:exam_number] == 2 && entry[:attributes][:question_number] == 19 }[:attributes]
      case part
      when "code"
        block = question[:content_blocks].find { |item| item[:type] == "code" }
        block[:code] = block[:code].gsub(/【[①②]】/, "0")
      when "prompt"
        question[:content_blocks].first[:text] = question[:content_blocks].first[:text].gsub(/\{\{[①②]\}\}/, "0")
      when "cells"
        question[:choices].first[:content_blocks].first[:cells].pop
      end
      assert_no_difference ["Question.count", "QuestionChoice.count"] do
        with_seed_entries(entries) do
          error = assert_raises(RuntimeError) { load Rails.root.join("db/seeds.rb") }
          assert_includes error.message, "模擬試験2 問19"
        end
      end
    end
  end

  private

  def with_seed_entries(entries)
    original = QuestionSeedSync.method(:collect)
    QuestionSeedSync.define_singleton_method(:collect) { entries }
    yield
  ensure
    QuestionSeedSync.define_singleton_method(:collect, original)
  end

  def synchronize
    QuestionWriter.transaction { @targets.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def code(exam)
    @questions.fetch(exam)[:content_blocks].find { |block| block[:type] == "code" }.fetch(:code)
  end

  def program(exam)
    code(exam).lines.map { |line| line.chomp.sub(/\A\d{2} /, "") }.reject { |line| line.strip.empty? }
  end

  def cells(choice)
    choice[:content_blocks].first.fetch(:cells)
  end

  def filled_program(exam, choice)
    program(exam).map { |line| line.gsub("【①】", cells(choice)[0]).gsub("【②】", cells(choice)[1]) }
  end

  def choice_explanation(exam, label)
    @questions[exam][:explanation_blocks].filter_map { |block| block[:text] }.find { |text| text.start_with?("#{label}：") }
  end

  def described_output(exam, label)
    value = choice_explanation(exam, label)[/表示は(-?\d+)となります/, 1]
    assert_not_nil value, "模試#{exam} 問19 #{label}の出力説明"
    value.to_i
  end

  def table_rows(exam)
    @questions[exam][:explanation_blocks].find { |block| block[:type] == "table" }.fetch(:rows)
  end

  def string_rows(rows)
    rows.map { |row| row.map(&:to_s) }
  end

  def array_assignment(line)
    JSON.parse(line.split(" = ", 2).last)
  end

  # Execute the displayed subset, including indentation, on an isolated receiver.
  # No correct-answer flag is consulted when translating or executing the program.
  def execute(lines)
    translated, nesting = [], []
    lines.each do |line|
      indent = line[/\A */].size
      statement = line.strip
      branch = statement == "else:" || statement == "そうでなければ:"
      while nesting.any? && (indent < nesting.last || (indent == nesting.last && !branch))
        translated << "end"
        nesting.pop
      end
      header = true
      ruby = case statement
      when /\Afor (\w+) in range\((.+), (.+)\):\z/
        "(#{$2}...#{$3}).each do |#{$1}|"
      when /\Afor (\w+) in (\w+):\z/
        "#{$2}.each do |#{$1}|"
      when /\Adef (.+):\z/
        "def #{$1}"
      when /\Aif (.+):\z/, /\Aもし (.+) なら:\z/
        "if #{$1}"
      when /\A(.+) の間繰り返す:\z/
        "while #{$1}"
      when "else:", "そうでなければ:"
        header = false
        "else"
      else
        header = false
        statement
      end
      nesting << indent if header
      ruby = ruby.gsub("//", "/").gsub(/要素数\((\w+)\)/, '\1.length')
        .gsub(/(\w+)\.append\((.+)\)/, '\1.push(\2)')
        .gsub(/0 (<=|<) candidate (<=|<) 6/) { "0 #{$1} candidate && candidate #{$2} 6" }
        .gsub(/(a\[.+?\]) と (a\[.+?\]) を交換する/) { "#{$1}, #{$2} = #{$2}, #{$1}" }
        .sub(/\Aprint\(/, "record_output(")
      translated << ruby
    end
    translated.concat(["end"] * nesting.size)
    runner = Object.new
    runner.instance_variable_set(:@outputs, [])
    runner.instance_variable_set(:@rows, [])
    runner.define_singleton_method(:record_output) { |value| @outputs << value }
    runner.define_singleton_method(:record_row) { |*values| @rows << values }
    translated << "{ outputs: @outputs, rows: @rows, state: binding.local_variables.to_h { |key| [key, binding.local_variable_get(key)] } }"
    runner.instance_eval(translated.join("\n"), "displayed_question_19", 1)
  end
end
