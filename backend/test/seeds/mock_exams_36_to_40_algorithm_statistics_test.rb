require "test_helper"
require "json"
require "date"

class MockExams36To40AlgorithmStatisticsTest < ActiveSupport::TestCase
  EXAMS = (36..40).to_a.freeze

  setup do
    @questions = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") }
    end.to_h { |entry| [[entry[:exam_number], entry[:attributes][:question_number]], entry[:attributes]] }
  end

  test "問19の全二十肢をseedの入力と処理で実行して正答一意性と全経過を検算する" do
    EXAMS.each do |exam|
      question = question(exam, 19)
      source = question[:content_blocks].find { |block| block[:type] == "code" }.fetch(:code)
      input = JSON.parse(source[/data = (\[[\d, ]+\])/, 1])
      expected = algorithm_goal(exam, input, source)
      runs = question[:choices].to_h do |choice|
        code = if exam == 37
          move_reset(source, choice_text(choice))
        elsif exam == 39
          source
        else
          assert_equal 1, source.scan("【①】").size
          source.sub("【①】", choice_text(choice))
        end
        [choice[:label], Pseudocode.new(code).run]
      end
      matching = question[:choices].select do |choice|
        result = exam == 39 ? number(choice_text(choice)) : runs.fetch(choice[:label]).fetch(:output)
        result == expected
      end
      assert_equal 1, matching.size, "#{exam}-19 must have one executable answer"
      assert_equal matching.map { |choice| choice[:label] }, question[:choices].select { |choice| choice[:correct] }.map { |choice| choice[:label] }
      correct_run = runs.fetch(matching.first[:label])
      assert_equal expected, correct_run[:output]
      assert_trace(exam, question, input, correct_run)
      assert_algorithm_explanations(exam, question, source, runs)
    end
  end

  test "問20の順序尺度の中央値を人数表から復元し四肢の対応を検算する" do
    q = question(36, 20)
    table = q[:content_blocks].find { |block| block[:type] == "table" }
    codes, counts = table[:rows].map { |row| row.drop(1).map { |cell| number(cell) } }
    data = codes.zip(counts).flat_map { |code, count| [code] * count.to_i }.sort
    assert_equal 10, data.size
    median = (data[(data.size - 1) / 2] + data[data.size / 2]) / 2.0
    assert_equal 2, median
    response = table[:headers].drop(1).fetch(codes.index(median))
    assert_equal "ふつう", response
    # Two strictly increasing recodings preserve the same categories/order but
    # have unequal category gaps, so equal integer codes do not prove equal gaps.
    assert_equal [0, 1, 2].sort, [0, 1, 2]
    assert_equal [0, 1, 100].sort, [0, 1, 100]
    assert_not_equal 1 - 0, 100 - 1
    matches = q[:choices].select do |choice|
      text = choice_text(choice)
      candidate_response = text[/中央値に対応する回答は「([^」]+)」/, 1]
      does_not_guarantee_equal_gaps = text.include?("差が等しいことを保証しない")
      candidate_response == response && does_not_guarantee_equal_gaps
    end
    assert_answer q, matches
    assert_includes explanations(q), "5番目・6番目はいずれも2"
  end

  test "問20の正の倍率と符号反転を相関〇点六の独立した小データで検算する" do
    q = question(37, 20)
    text = q[:content_blocks].map { |block| block[:text] }.compact.join("\n")
    stated_r = text[/相関係数は([0-9.]+)で/, 1].to_f
    divisor = text[/Z＝Y÷([0-9.]+)/, 1].to_f
    constant = text[/W＝([0-9.]+)−Y/, 1].to_f
    assert_equal 0.6, stated_r
    assert_operator divisor, :>, 0
    x = [1, 1, 3, 3]
    y = [36, 52, 48, 64]
    assert_in_delta stated_r, correlation(x, y), 1e-12
    rz = correlation(x, y.map { |value| value / divisor })
    rw = correlation(x, y.map { |value| constant - value })
    assert_in_delta stated_r, rz, 1e-12
    assert_in_delta(-stated_r, rw, 1e-12)
    assert_in_delta rz.abs, rw.abs, 1e-12
    matches = q[:choices].select do |choice|
      values = choice_text(choice).tr("−", "-").scan(/-?\d+\.\d+/).map(&:to_f)
      values *= 2 if values.size == 1
      assert_equal 2, values.size
      (values[0] - rz).abs < 1e-12 && (values[1] - rw).abs < 1e-12
    end
    assert_answer q, matches
  end

  test "問20の表記統一と欠測値補完を実際の四記録で区別する" do
    q = question(38, 20)
    rows = q[:content_blocks].find { |block| block[:type] == "table" }.fetch(:rows)
    assert_equal 4, rows.map(&:first).uniq.size
    dates = rows.map { |row| Date.new(*row[1].scan(/\d+/).map(&:to_i)) }
    assert_equal 1, dates.first(3).uniq.size
    counts = rows.map { |row| row[2] == "空欄" ? nil : number(row[2]) }
    assert_equal [0, 2, nil, 4], counts
    assert_equal 3, counts.compact.size
    assert_equal 1, counts.compact.count(&:zero?)
    assert_not_equal counts, counts.map { |value| value || 0 }
    matches = q[:choices].select do |choice|
      text = choice_text(choice)
      text.include?("空欄を0へ置き換える") && text.include?("元の記録の意味を保つ表記の統一")
    end
    assert_answer q, matches
    assert_includes explanations(q), "記録がある生徒はA・B・Dの3人"
  end

  test "問20のクロス集計表から分子分母を抽出し六十と四十五パーセントを検算する" do
    q = question(39, 20)
    rows = q[:content_blocks].find { |block| block[:type] == "table" }.fetch(:rows)
    a, b, total = rows.map { |row| row.drop(1).map { |cell| number(cell) } }
    assert_equal a.zip(b).map { |x, y| x + y }, total
    [a, b, total].each { |used, unused, all| assert_equal all, used + unused }
    percentages = [100.0 * a[0] / total[0], 100.0 * a[0] / a[2]]
    assert_equal [60.0, 45.0], percentages
    matches = q[:choices].select do |choice|
      choice_text(choice).scan(/[①②]([\d.]+)％/).flatten.map(&:to_f) == percentages
    end
    assert_answer q, matches
    calculation_table = q[:explanation_blocks].find { |block| block[:type] == "table" }
    assert_equal percentages, calculation_table[:rows].map { |row| row.last[/＝([\d.]+)％/, 1].to_f }
  end

  test "問20の分散と三つの誤答計算を表の全数値から独立計算する" do
    q = question(40, 20)
    table = q[:content_blocks].find { |block| block[:type] == "table" }
    a, b = table[:rows].map { |row| row[1].split("，").map(&:to_f) }
    assert_equal 4, a.size
    assert_equal a.size, b.size
    shift = b.first - a.first
    assert_equal [shift] * a.size, a.zip(b).map { |x, y| y - x }
    assert_equal number(q[:content_blocks].first[:text][/それぞれ(\d+)を加え/, 1]), shift
    mean = b.sum / b.size
    differences = b.map { |value| value - mean }
    square_sum = differences.sum { |value| value**2 }
    variance = square_sum / b.size
    a_mean = a.sum / a.size
    a_variance = a.sum { |value| (value - a_mean)**2 } / a.size
    assert_equal 6, mean
    assert_equal 5, variance
    assert_equal a_variance, variance
    wrong_results = [a_variance + shift, square_sum, differences.sum / b.size]
    assert_equal [7.0, 20.0, 0.0], wrong_results
    assert_equal (wrong_results + [variance]).sort, q[:choices].map { |choice| number(choice_text(choice)) }.sort
    assert_answer q, q[:choices].select { |choice| number(choice_text(choice)) == variance }
    assert_includes explanations(q), "20÷4＝5"
  end

  private

  def question(exam, number) = @questions.fetch([exam, number])
  def choice_text(choice) = choice[:content_blocks].map { |block| block.fetch(:text) }.join("\n")
  def explanations(question) = question[:explanation_blocks].map { |block| block[:text] }.compact.join("\n")
  def number(text) = Float(text.to_s[/[+-]?\d+(?:\.\d+)?/])

  def assert_answer(question, matches)
    assert_equal 1, matches.size
    assert_equal question[:choices].select { |choice| choice[:correct] }.map { |choice| choice[:label] }, matches.map { |choice| choice[:label] }
  end

  def correlation(x, y)
    mx, my = x.sum.to_f / x.size, y.sum.to_f / y.size
    dx, dy = x.map { |v| v - mx }, y.map { |v| v - my }
    dx.zip(dy).sum { |a, b| a * b } / Math.sqrt(dx.sum { |v| v**2 } * dy.sum { |v| v**2 })
  end

  def algorithm_goal(exam, input, code)
    case exam
    when 36
      input.each_index.map { |index| input.first(index + 1).sum }
    when 37
      input.chunk(&:positive?).select(&:first).map { |_, values| values.size }.max || 0
    when 38
      input.each_index.select { |index| input[index] == input.min }.last
    when 39
      limit = code[/limit = (\d+)/, 1].to_i
      index = input.each_index.find { |i| input.first(i + 1).sum >= limit }
      index ? input.first(index + 1).sum : input.sum
    when 40
      input.each_cons(2).count { |previous, current| current < previous }
    end
  end

  # Apply exactly the line-movement instruction in each 37-19 choice.  This
  # constructs a candidate program, rather than assigning outcomes by label.
  def move_reset(source, choice)
    lines = source.lines.map(&:chomp)
    reset_number = if choice.include?("elseを設け")
      choice[/，(\d+)行をその中へ/, 1]
    else
      choice[/\A(\d+)行/, 1]
    end
    raise "unrecognized reset movement" unless reset_number
    reset = lines.delete_at(lines.index { |line| line.start_with?(reset_number + " ") })
    statement = reset.sub(/\A\d+\s+/, "")
    if (match = choice.match(/(\d+)行の条件が成立したときに，(\d+)行の直前/))
      conditional = lines.find { |line| line.start_with?(match[1] + " ") }
      indent = conditional.match(/\A\d+ ( *)/)[1].size + 4
      position = lines.index { |line| line.start_with?(match[2] + " ") }
      lines.insert(position, "#{reset_number} #{' ' * indent}#{statement}")
    elsif (match = choice.match(/\A(\d+)行のifに対応するelse/))
      position = lines.index { |line| line.start_with?(match[1] + " ") }
      indent = lines[position].match(/\A\d+ ( *)/)[1].size
      position += 1
      position += 1 while position < lines.size && lines[position].match(/\A\d+ ( *)/)[1].size > indent
      lines.insert(position, "00 #{' ' * indent}else:", "#{reset_number} #{' ' * (indent + 4)}#{statement}")
    elsif (match = choice.match(/字下げをなくし，\d+行の反復が全て終了した後，(\d+)行の直前/))
      position = lines.index { |line| line.start_with?(match[1] + " ") }
      lines.insert(position, "#{reset_number} #{statement}")
    else
      raise "unrecognized movement #{choice}"
    end
    lines.join("\n")
  end

  def assert_trace(exam, question, input, result)
    table = question[:explanation_blocks].find { |block| block[:type] == "table" }
    actual = result[:trace].map do |step|
      before, after = step.values_at(:before, :after)
      case exam
      when 36 then [after["i"].to_s, after["data"].inspect]
      when 37 then %w[x run best].map { |name| after.fetch(name).to_s }
      when 38 then [after["i"], input[after["i"]], after["pos"]].map(&:to_s)
      when 39 then [after["x"].to_s, after["total"].to_s, step[:broken] ? "成立し，反復を終了" : "成立しない"]
      when 40 then [after["i"], input[after["i"]], before["prev"], after["count"]].map(&:to_s)
      end
    end
    actual.unshift(["更新前", input.inspect]) if exam == 36
    assert_equal table.fetch(:rows), actual, "#{exam}-19 trace"
  end

  def assert_algorithm_explanations(exam, question, source, runs)
    question[:choices].each do |choice|
      explanation = question[:explanation_blocks].find { |block| block[:text]&.start_with?(choice[:label] + "：") }.fetch(:text)
      output = runs.fetch(choice[:label])[:output]
      case exam
      when 36
        assert_includes explanation, output.inspect
      when 37
        assert_match(/(?:bestの表示も|表示は|最後の0でも|正の値の個数)#{output}(?:と|を)/, explanation)
      when 38, 40
        assert_match(/表示は#{output}とな[るり]/, explanation)
      when 39
        next if choice[:correct]
        condition = explanation[/06行の条件を(.+?)へ変更/, 1]
        assert condition
        original = source[/if (.+):/, 1]
        changed = source.sub("if #{original}:", "if #{condition}:")
        assert_equal number(choice_text(choice)), Pseudocode.new(changed).run[:output]
      end
    end
  end

  # Deliberately restricted interpreter for the displayed teaching pseudocode.
  # No eval or execution of seed-provided Ruby/Python is used.  Assignments,
  # comparisons, iteration order and statement placement come from the seed.
  class Pseudocode
    def initialize(source)
      @lines = source.lines.map do |line|
        match = line.chomp.match(/\A\d+ ( *)(.+)\z/) or raise "bad numbered line #{line}"
        [match[1].size, match[2]]
      end
      @cursor = 0
      @tree = parse(0)
      raise "unparsed code" unless @cursor == @lines.size
      @environment, @trace = {}, []
    end

    def run
      execute(@tree)
      { output: @output, trace: @trace }
    end

    private

    def parse(indent)
      nodes = []
      while @cursor < @lines.size && @lines[@cursor][0] == indent
        _, statement = @lines[@cursor]
        @cursor += 1
        node = { statement: statement }
        if @cursor < @lines.size && @lines[@cursor][0] > indent
          node[:body] = parse(@lines[@cursor][0])
        end
        if statement.start_with?("if ") && @cursor < @lines.size && @lines[@cursor] == [indent, "else:"]
          @cursor += 1
          node[:else] = parse(@lines.fetch(@cursor)[0])
        end
        nodes << node
      end
      nodes
    end

    def execute(nodes)
      nodes.each do |node|
        statement = node[:statement]
        case statement
        when /\Aif (.+):\z/
          branch = compare(Regexp.last_match(1)) ? node.fetch(:body) : node.fetch(:else, [])
          return :break if execute(branch) == :break
        when /\A(\w+)を(.+)から(.+)まで1ずつ(増やし|減らし)ながら繰り返す:\z/
          variable, first, last, direction = Regexp.last_match.captures
          first, last = expression(first), expression(last)
          values = direction == "増やし" ? (first <= last ? (first..last).to_a : []) : (first >= last ? first.downto(last).to_a : [])
          iterate(variable, values, node.fetch(:body))
        when /\A(\w+)をdataの先頭から順に取り出しながら繰り返す:\z/
          iterate(Regexp.last_match(1), @environment.fetch("data"), node.fetch(:body))
        when "break"
          return :break
        when /\A表示する\((\w+)\)\z/
          @output = copy(expression(Regexp.last_match(1)))
        when /\A(data\[.+\]|\w+) = (.+)\z/
          target, value = Regexp.last_match.captures
          value = expression(value)
          if (match = target.match(/\Adata\[(.+)\]\z/))
            @environment.fetch("data")[expression(match[1])] = value
          else
            @environment[target] = value
          end
        else
          raise "unsupported statement #{statement}"
        end
      end
      nil
    end

    def iterate(variable, values, body)
      values.each do |value|
        @environment[variable] = value
        before = snapshot
        broken = execute(body) == :break
        @trace << { before: before, after: snapshot, broken: broken }
        break if broken
      end
    end

    def expression(raw)
      raw = raw.strip
      return JSON.parse(raw) if raw.match?(/\A\[[\d, ]+\]\z/)
      return raw.to_i if raw.match?(/\A\d+\z/)
      return @environment.fetch("data").size if raw == "要素数(data)"
      if (match = raw.match(/\Adata\[([^\[\]]+)\]\z/))
        return @environment.fetch("data").fetch(expression(match[1]))
      end
      # The only arithmetic in these five programs is a sum/difference of
      # simple atoms; bracket nesting is respected before splitting.
      depth = 0
      raw.chars.each_with_index do |char, index|
        depth += 1 if char == "["
        depth -= 1 if char == "]"
        next unless depth.zero? && index.positive? && ["+", "-"].include?(char)
        return expression(raw[0...index]).public_send(char, expression(raw[(index + 1)..]))
      end
      @environment.fetch(raw)
    end

    def compare(raw)
      match = raw.match(/\A(.+?)\s*(>=|<=|==|>|<)\s*(.+)\z/) or raise "bad comparison #{raw}"
      expression(match[1]).public_send(match[2], expression(match[3]))
    end

    def copy(value) = value.is_a?(Array) ? value.dup : value
    def snapshot = @environment.transform_values { |value| copy(value) }
  end
end
