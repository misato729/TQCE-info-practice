require "test_helper"

class MockExams16To20AlgorithmTest < ActiveSupport::TestCase
  EXAMS = (16..20).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze

  setup do
    entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @questions = entries.select { |entry| entry.fetch(:attributes).fetch(:question_number) == 19 }
      .to_h { |entry| [entry.fetch(:exam_number), entry.fetch(:attributes)] }
  end

  test "五問は表示されたコードと四候補及び途中経過と各選択肢の解説を持つ" do
    assert_equal EXAMS, @questions.keys.sort
    @questions.each do |exam, question|
      assert_equal "information_specialized", question.fetch(:category_code)
      assert_equal LABELS, question.fetch(:choices).map { |choice| choice.fetch(:label) }
      assert_equal 1, question.fetch(:choices).count { |choice| choice.fetch(:correct) }
      assert_equal 1, question.fetch(:content_blocks).count { |block| block[:type] == "code" }
      assert question.fetch(:explanation_blocks).any? { |block| block[:type] == "table" }
      question.fetch(:choices).each do |choice|
        assert_equal 2, cells(choice).size
        assert explanation(exam, choice.fetch(:label)).present?
      end
      next if exam == 20

      assert_equal %w[① ②], code(exam).scan(/【([①②])】/).flatten.uniq
      question.fetch(:choices).map { |choice| cells(choice) }.transpose.each do |column|
        assert_equal [2, 2], column.tally.values.sort
      end
    end
  end

  test "度数配列と同数時の更新を全候補で実行し全ての途中経過を照合する" do
    lines = program(16)
    assert_match(/\Afreq\[【①】\] = freq\[【①】\] \+ 1\z/, lines[3].strip)
    assert_match(/\Aif freq\[v\] 【②】 freq\[best\]:\z/, lines[6].strip)
    assert_equal "best = v", lines[7].strip
    data = array_assignment(lines[0], "data")
    initial = array_assignment(lines[1], "freq")
    observed = data.tally
    count = observed.values.max
    expected = [observed.select { |_, frequency| frequency == count }.keys.max, count]
    answers = []

    @questions.fetch(16).fetch(:choices).each do |choice|
      index_expression, comparison = cells(choice)
      frequency = initial.dup
      python_range(lines[2], "i", {}).each do |i|
        index = value(index_expression, { "data" => data, "i" => i })
        frequency[index] += 1
      end
      best = integer_assignment(lines[4], "best")
      rows = []
      python_range(lines[5], "v", {}).each do |v|
        previous = best
        updated = compare(frequency[v], comparison, frequency[best])
        best = v if updated
        rows << [v, frequency[v], previous, updated ? "あり" : "なし", best]
      end
      output = [best, frequency[best]]
      matches = output == expected
      assert_equal choice.fetch(:correct), matches
      answers << choice.fetch(:label) if matches
      if choice.fetch(:correct)
        assert_equal table_rows(16, "整数 v"), string_rows(frequency.each_with_index.map { |frequency_value, v| [v, frequency_value] })
        assert_equal table_rows(16, "調べる v"), string_rows(rows)
      else
        described = explanation(16, choice.fetch(:label)).match(/表示は\s*(\d+)\s+(\d+)/).captures.map(&:to_i)
        assert_equal described, output
      end
    end
    assert_equal 1, answers.size
  end

  test "同じ配列への抽出を全候補で実行し読取値と書込位置と有効範囲を照合する" do
    lines = program(17)
    assert_equal "a[【①】] = a[i]", lines[4].strip
    assert_equal "k = 【②】", lines[5].strip
    bounds = lines[3].match(/if a\[i\] > (-?\d+) and a\[i\] % (\d+) == (\d+):/).captures.map(&:to_i)
    data = array_assignment(lines[0], "a")
    qualifying = ->(entry) { entry > bounds[0] && entry % bounds[1] == bounds[2] }
    expected = data.select(&qualifying)
    matches = @questions.fetch(17).fetch(:choices).count do |choice|
      write_expression, update_expression = cells(choice)
      a = data.dup
      k = integer_assignment(lines[1], "k")
      rows = []
      python_range(lines[2], "i", {}).each do |i|
        read = a.fetch(i)
        selected = qualifying.call(read)
        position = "―"
        if selected
          context = { "i" => i, "k" => k }
          position = value(write_expression, context)
          assert_operator position, :<=, i if choice.fetch(:correct)
          a[position] = read
          k = value(update_expression, context)
        end
        rows << [i, read, selected ? "はい" : "いいえ", position, k, a.first(k).inspect]
      end
      valid = k == expected.size && a.first(k) == expected
      assert_equal choice.fetch(:correct), valid
      if choice.fetch(:correct)
        assert_equal table_rows(17, "読取位置 i"), string_rows(rows)
      else
        described = explanation(17, choice.fetch(:label))
        assert_match(/k\s*(?:は|が)#{k}/, described)
        displayed_array = described[/\[[\d, -]+\]/]
        assert_equal a.first(k), JSON.parse(displayed_array) if displayed_array
      end
      valid
    end
    assert_equal 1, matches
  end

  test "隣接差の符号とprevの更新を全候補で実行し途中経過と誤答出力を照合する" do
    lines = program(18)
    assert_equal "prev = Data[0]", lines[1]
    assert_equal "delta = 【①】", lines[4].strip
    assert_equal "Diffの末尾にdeltaを追加する", lines[5].strip
    assert_equal "prev = 【②】", lines[6].strip
    data = array_assignment(lines[0], "Data")
    expected = data.each_cons(2).map { |first, second| second - first }
    matches = @questions.fetch(18).fetch(:choices).count do |choice|
      subtract, update = cells(choice)
      prev = data.first
      output, rows = [], []
      japanese_range(lines[3], "i", { "Data" => data }).each do |i|
        old = prev
        context = { "Data" => data, "i" => i, "prev" => prev }
        delta = value(subtract, context)
        output << delta
        prev = value(update, context.merge("delta" => delta))
        rows << [i, data[i], old, delta, prev]
      end
      valid = output == expected
      assert_equal choice.fetch(:correct), valid
      if choice.fetch(:correct)
        assert_equal table_rows(18, "i"), string_rows(rows)
      else
        displayed = explanation(18, choice.fetch(:label))[/出力は［([^］]+)］/, 1]
        assert_equal output, displayed.tr("−，", "-,").split(",").map(&:to_i)
      end
      valid
    end
    assert_equal 1, matches
  end

  test "整数除算と桁の更新を全候補で実行し途中経過と誤答出力を照合する" do
    lines = program(19)
    assert_equal "x > 0 の間繰り返す:", lines[2]
    assert_equal "rev = 【①】", lines[4].strip
    assert_equal "x = 【②】", lines[5].strip
    initial = integer_assignment(lines[0], "x")
    expected = initial.to_s.reverse.to_i
    digit_expression = lines[3].strip.delete_prefix("digit = ")
    matches = @questions.fetch(19).fetch(:choices).count do |choice|
      append, remove = cells(choice)
      x = initial
      rev = integer_assignment(lines[1], "rev")
      rows = []
      while x.positive?
        old = x
        digit = value(digit_expression, { "x" => x })
        context = { "x" => x, "rev" => rev, "digit" => digit }
        rev = value(append, context)
        x = value(remove, context)
        rows << [rows.size + 1, old, digit, rev, x]
        assert_operator rows.size, :<=, initial.to_s.size
      end
      valid = rev == expected
      assert_equal choice.fetch(:correct), valid
      if choice.fetch(:correct)
        assert_equal table_rows(19, "反復"), string_rows(rows)
      else
        described = explanation(19, choice.fetch(:label))[/出力は.*?(\d+)となる/, 1].to_i
        assert_equal described, rev
      end
      valid
    end
    assert_equal 1, matches
  end

  test "二重ループの判定位置と各添字の組を実行し正答一意性と全途中経過を照合する" do
    lines = program(20)
    assert_equal "n = 要素数(Data)", lines[1]
    assert_equal "            pairs = pairs + 1", lines[7]
    assert_equal "        checks = checks + 1", lines[8]
    data = array_assignment(lines[0], "Data")
    target = lines[6][/Data\[i\] \+ Data\[j\] == (\d+)/, 1].to_i
    checks, pairs = integer_assignment(lines[2], "checks"), integer_assignment(lines[3], "pairs")
    rows = []
    japanese_range(lines[4], "i", { "n" => data.size }).each do |i|
      indices = japanese_range(lines[5], "j", { "i" => i, "n" => data.size }).to_a
      wins = []
      indices.each do |j|
        if data.fetch(i) + data.fetch(j) == target
          pairs += 1
          wins << "（#{i}，#{j}）"
        end
        checks += 1
      end
      range = indices.size == 1 ? indices.first.to_s : "#{indices.first}〜#{indices.last}"
      rows << [i, range, indices.size, wins.any? ? wins.join("，") : "なし"]
    end
    reference = (0...data.size).to_a.combination(2).to_a
    assert_equal reference.size, checks
    assert_equal reference.count { |i, j| data[i] + data[j] == target }, pairs
    assert_equal table_rows(20, "i"), string_rows(rows)
    matches = @questions.fetch(20).fetch(:choices).count do |choice|
      valid = cells(choice).map(&:to_i) == [checks, pairs]
      assert_equal choice.fetch(:correct), valid
      valid
    end
    assert_equal 1, matches
  end

  test "二重ループの誤答解説を各モデルで検算し対角成分を加える両方の範囲変更を確認する" do
    lines = program(20)
    data = array_assignment(lines[0], "Data")
    target = lines[6][/Data\[i\] \+ Data\[j\] == (\d+)/, 1].to_i
    candidates = (0...data.size).to_a.combination(2).to_a
    wins = candidates.select { |i, j| data[i] + data[j] == target }
    distinct_value_pairs = wins.map { |i, j| [data[i], data[j]].sort }.uniq
    assert_equal cells(@questions.fetch(20).fetch(:choices)[0]).map(&:to_i), [candidates.size, distinct_value_pairs.size]

    diagonal_explanation = explanation(20, "イ")
    outer, inner = diagonal_explanation.match(/外側の反復をi=(.+?)から(.+?)まで，内側の反復をj=(.+?)から(.+?)まで/).captures.each_slice(2).to_a
    assert_equal ["0", "n-1"], outer
    assert_equal ["i", "n-1"], inner
    diagonal_pairs = []
    (value(outer[0], {})..value(outer[1], { "n" => data.size })).each do |i|
      (value(inner[0], { "i" => i })..value(inner[1], { "n" => data.size })).each { |j| diagonal_pairs << [i, j] }
    end
    diagonal_output = [diagonal_pairs.size, diagonal_pairs.count { |i, j| data[i] + data[j] == target }]
    assert_equal cells(@questions.fetch(20).fetch(:choices)[1]).map(&:to_i), diagonal_output
    # Changing only the inner loop misses the final self-pair comparison.
    inner_only = diagonal_pairs.reject { |i, _| i == data.size - 1 }
    assert_equal diagonal_output.first - 1, inner_only.size
    assert_equal 21, diagonal_output.first
    assert_equal 4, diagonal_output.last

    ordered = (0...data.size).to_a.permutation(2).to_a
    ordered_output = [ordered.size, ordered.count { |i, j| data[i] + data[j] == target }]
    assert_equal cells(@questions.fetch(20).fetch(:choices)[3]).map(&:to_i), ordered_output
    assert_includes explanation(20, "エ"), "（i，j）と（j，i）"
  end

  private

  def code(exam)
    @questions.fetch(exam).fetch(:content_blocks).find { |block| block[:type] == "code" }.fetch(:code)
  end

  def program(exam)
    code(exam).lines.map { |line| line.chomp.sub(/\A\d{2} /, "") }
  end

  def cells(choice)
    block = choice.fetch(:content_blocks).first
    block.fetch(:type) == "table" ? block.fetch(:rows).first : block.fetch(:cells)
  end

  def explanation(exam, label)
    @questions.fetch(exam).fetch(:explanation_blocks).find { |block| block[:type] == "text" && block.fetch(:text).start_with?("#{label}：") }.fetch(:text)
  end

  def table_rows(exam, first_header)
    @questions.fetch(exam).fetch(:explanation_blocks).find { |block| block[:type] == "table" && block.fetch(:headers).first == first_header }.fetch(:rows)
  end

  def string_rows(rows)
    rows.map { |row| row.map(&:to_s) }
  end

  def array_assignment(line, variable)
    JSON.parse(line.match(/\A#{Regexp.escape(variable)} = (\[[\d, -]+\])\z/)[1])
  end

  def integer_assignment(line, variable)
    Integer(line.match(/\A#{Regexp.escape(variable)} = (-?\d+)\z/)[1])
  end

  def python_range(line, variable, context)
    first, last = line.strip.match(/\Afor #{variable} in range\((.+?), (.+?)\):\z/).captures
    value(first, context)...value(last, context)
  end

  def japanese_range(line, variable, context)
    first, last = line.strip.match(/\A#{variable}を(.+?)から(.+?)まで1ずつ増やしながら繰り返す:\z/).captures
    value(first, context)..value(last, context)
  end

  # This deliberately supports only the arithmetic displayed in these five seeds.
  # It does not execute Ruby or evaluate arbitrary source text.
  def value(expression, context)
    expression = expression.tr("−＋×", "-+*").delete(" ")
    return Integer(expression) if expression.match?(/\A-?\d+\z/)
    return context.fetch(expression) if expression.match?(/\A[a-zA-Z]+\z/)
    if (match = expression.match(/\A([a-zA-Z]+)\[([a-zA-Z]+|\d+)\]\z/))
      return context.fetch(match[1]).fetch(value(match[2], context))
    end
    if (match = expression.match(/\A要素数\(([a-zA-Z]+)\)\z/))
      return context.fetch(match[1]).size
    end
    if (match = expression.match(/\A(.+)([+-])(.+)\z/))
      first, last = value(match[1], context), value(match[3], context)
      return match[2] == "+" ? first + last : first - last
    end
    if (match = expression.match(/\A(.+?)(\/\/|\*|%)(.+)\z/))
      first, last = value(match[1], context), value(match[3], context)
      return first.div(last) if match[2] == "//"
      return first * last if match[2] == "*"
      return first % last
    end
    raise "未対応の検算式: #{expression}"
  end

  def compare(first, operator, last)
    return first >= last if operator == ">="
    return first > last if operator == ">"
    raise "未対応の比較演算子: #{operator}"
  end
end
