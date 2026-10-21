require "test_helper"
require "json"
require "date"

class MockExams41To50AlgorithmStatisticsTest < ActiveSupport::TestCase
  EXAMS = (41..50).to_a.freeze

  setup do
    @questions = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") }
    end.to_h { |entry| [[entry[:exam_number], entry[:attributes][:question_number]], entry[:attributes]] }
  end

  test "問19の十問四十候補を実seedから実行し独立目的値と全肢解説を照合する" do
    assert_equal 200, @questions.size
    candidates_checked = 0
    EXAMS.each do |exam|
      q = question(exam, 19)
      source = q[:content_blocks].find { |block| block[:type] == "code" }.fetch(:code)
      input = exam == 50 ? source[/\bx = (\d+)/, 1].to_i : JSON.parse(source[/data = (\[[\d, \-]+\])/, 1])
      expected = purpose(exam, input, source)
      runs = q[:choices].to_h do |choice|
        candidates_checked += 1
        [choice[:label], Pseudocode.new(candidate(exam, source, choice)).run]
      end
      matches = q[:choices].select { |choice| runs.fetch(choice[:label])[:output] == expected }
      assert_answer q, matches, "#{exam}-19"
      assert_algorithm_explanations(exam, q, runs)
      assert_trace(exam, q, input, runs.fetch(matches.first[:label]))
    end
    assert_equal 40, candidates_checked
  end

  test "問20の尺度と相関の四肢を概念間の対応で判定する" do
    q = question(41, 20)
    # Changing Celsius to Fahrenheit changes a ratio but preserves the
    # corresponding difference: equal intervals do not give an absolute zero.
    assert_equal 20, Rational(104 - 68, 1) / Rational(9, 5)
    assert_not_equal Rational(40, 20), Rational(104, 68)
    assert_answer q, q[:choices].select { |c|
      t = choice_text(c)
      t.include?("室温は間隔尺度") && t.include?("時間は比例尺度") && t.include?("40分は20分の2倍")
    }, "41-20"
    assert_includes explanations(q), "40÷20＝2"

    q = question(42, 20)
    r = question_text(q)[/相関係数は([−\-\d.]+)/, 1].tr("−", "-").to_f
    assert_operator r, :<, 0
    assert_operator r.abs, :>, 0.20
    assert_answer q, q[:choices].select { |c|
      t = choice_text(c)
      t.include?("料金が高いほど利用回数が小さい") && t.include?("利用料金を説明変数，利用回数を目的変数")
    }, "42-20"
    assert_includes explanations(q), "0.70は0.20より1に近く"
    assert_includes explanations(q), "相関係数−0.70から，1円当たり何回変わるかという傾きは定められない"

    q = question(46, 20)
    rows = content_table(q)[:rows]
    assert_equal ["徒歩", "自転車", "公共交通"], rows.first.drop(1)
    assert_equal ["不満", "ふつう", "満足"], rows.last.drop(1)
    # Two order-preserving codings have unequal successive gaps. Arbitrary
    # integer labels alone therefore cannot prove equal measured differences.
    assert_equal [1, 2, 100], [1, 2, 100].sort
    assert_not_equal 2 - 1, 100 - 2
    assert_answer q, q[:choices].select { |c|
      t = choice_text(c)
      t.include?("通学手段の符号は名義尺度") && t.include?("満足度の符号は順序尺度") && t.include?("差の大きさまでは定められない")
    }, "46-20"

    q = question(47, 20)
    # Independent illustrative observations, not the question's unprovided
    # raw observations. Covariance products commute when X/Y are exchanged.
    x, y = [1, 1, 3, 3], [13, 19, 21, 27]
    assert_in_delta 0.80, correlation(x, y), 1e-12
    assert_in_delta 0.80, correlation(y, x), 1e-12
    matches = q[:choices].select do |c|
      t = choice_text(c)
      coefficient = t[/([−\-]?0\.80)/, 1].tr("−", "-").to_f
      coefficient == correlation(x, y) && t.include?("所要時間Yを説明変数，通学距離Xを目的変数")
    end
    assert_answer q, matches, "47-20"
    assert_includes explanations(q), "YとXの相関係数も0.80"
  end

  test "問20の同一人物の別手続きと重複入力を表示表から区別する" do
    q = question(43, 20)
    records = content_table(q)[:rows].map do |_, transaction, person, date, books|
      [transaction, person, Date.new(*date.split(/[\/-]/).map(&:to_i)), books.to_i]
    end
    assert_equal 4, records.size
    unique = records.uniq
    assert_equal 3, unique.size
    assert_equal 6, unique.sum(&:last)
    latest = unique.group_by { |row| row[1] }.values.map { |rows| rows.max_by { |row| row[2] } }
    assert_equal 2, latest.size
    assert_equal 4, latest.sum(&:last)
    assert_equal records[1], records[2]
    assert_equal records[0][1], records[1][1]
    assert_not_equal records[0][0], records[1][0]
    assert_answer q, q[:choices].select { |c| choice_text(c).include?("生徒IDがS01である行は，日付が最も新しい手続きの1件") }, "43-20"
    assert_includes explanations(q), "L101の2冊という有効な記録を失う"
    assert_includes explanations(q), "同じ1回の手続きを二重に数えない"
  end

  test "問20の群の人数を反映した平均を四つの誤計算まで検算する" do
    q = question(44, 20)
    (n1, m1), (n2, m2) = content_table(q)[:rows].map { |row| row.drop(1).map { |value| value.to_i } }
    expected = Rational(n1 * m1 + n2 * m2, n1 + n2)
    values = q[:choices].to_h { |c| [c[:label], choice_text(c).to_i] }
    assert_equal 6, expected
    assert_equal Rational(m1 + m2, 2), values.fetch("ア")
    assert_equal Rational(n2 * m1 + n1 * m2, n1 + n2), values.fetch("イ")
    assert_equal Rational(n1 * m1 + n2 * m2, 2), values.fetch("ウ")
    assert_answer q, q[:choices].select { |c| choice_text(c).to_i == expected }, "44-20"
    %w[8冊 10冊 12冊 6冊].each { |value| assert_includes explanations(q), value }
    assert_includes explanations(q), "（4×3＋12×1）÷（3＋1）＝24÷4＝6"
  end

  test "問20の外れ値候補は境界との等号と誤入力の断定を区別する" do
    q = question(45, 20)
    text = question_text(q)
    q1, q3 = text[/第1四分位数は(\d+)/, 1].to_i, text[/第3四分位数は(\d+)/, 1].to_i
    fence = q3 + Rational(3, 2) * (q3 - q1)
    assert_equal 30, fence
    assert_not 30 > fence
    assert 31 > fence
    assert_equal 26, q3 + q3 - q1
    assert_answer q, q[:choices].select { |c|
      t = choice_text(c)
      t.include?("境界は#{fence.to_i}分") && t.include?("候補となるのは31分") && t.include?("原因や理由を調べて") && !t.include?("誤入力に分類される")
    }, "45-20"
    assert_includes explanations(q), "18−10＝8分"
    assert_includes explanations(q), "18＋1.5×8＝30分"
    assert_includes explanations(q), "26分は18＋8"
  end

  test "問20の欠測は分析対象の列と有効なゼロを基準に平均を検算する" do
    q = question(48, 20)
    records = content_table(q)[:rows].map { |name, time, books| [name, time == "空欄" ? nil : time.to_i, books == "空欄" ? nil : books.to_i] }
    valid = records.select { |_, time, _| !time.nil? }
    complete = records.select { |_, time, books| !time.nil? && !books.nil? }
    assert_equal %w[A B D], valid.map(&:first)
    assert_equal %w[A D], complete.map(&:first)
    assert_equal 10, Rational(valid.sum { |row| row[1] }, valid.size)
    assert_equal 5, Rational(complete.sum { |row| row[1] }, complete.size)
    assert_answer q, q[:choices].select { |c| choice_text(c).include?("BとCを除いてAとDから計算") }, "48-20"
    assert_includes explanations(q), "(10+20+0)÷3=10"
    assert_includes explanations(q), "(10+0)÷2=5"
  end

  test "問20の総件数と人口千人当たりの件数の大小を各市の分母から求める" do
    q = question(49, 20)
    cities = content_table(q)[:rows].to_h { |name, population, count| [name, [population.delete(",").to_i, count.to_i]] }
    rates = cities.transform_values { |population, count| Rational(count * 1000, population) }
    assert_equal({ "A市" => 4, "B市" => 3 }, rates)
    expected = [cities.max_by { |_, (_, count)| count }.first, rates.max_by(&:last).first]
    assert_equal %w[B市 A市], expected
    assert_answer q, q[:choices].select { |c| choice_text(c).scan(/：([AB]市)/).flatten == expected }, "49-20"
    assert_includes explanations(q), "40÷10,000×1,000=4"
    assert_includes explanations(q), "120÷40,000×1,000=3"
  end

  test "問20の追加する値四候補を実際に並べ直して中央値を検算する" do
    q = question(50, 20)
    original = q[:content_blocks].find { |block| block[:type] == "code" }[:code].scan(/\d+/).map(&:to_i)
    assert_equal [1, 2, 3, 4, 6, 7, 9], original
    before = median(original)
    values = q[:choices].to_h { |c| [c[:label], median(original + [choice_text(c).to_i])] }
    assert_equal 4, before
    assert_equal({ "ア" => 5, "イ" => 5, "ウ" => Rational(9, 2), "エ" => 4 }, values)
    assert_answer q, q[:choices].select { |c| values.fetch(c[:label]) == before }, "50-20"
    q[:choices].each do |choice|
      added = choice_text(choice).to_i
      arranged = (original + [added]).sort
      explanation = q[:explanation_blocks].find { |b| b[:text]&.start_with?(choice[:label] + "：") }[:text]
      assert_includes explanation, arranged.join("，")
      assert_includes explanation, "中央値は#{values.fetch(choice[:label]).to_f.to_s.delete_suffix('.0')}冊" unless choice[:correct]
    end
  end

  private

  def question(exam, number) = @questions.fetch([exam, number])
  def question_text(q) = q[:content_blocks].filter_map { |b| b[:text] }.join("\n")
  def choice_text(c) = c[:content_blocks].first.fetch(:text)
  def explanations(q) = q[:explanation_blocks].filter_map { |b| b[:text] || b[:code] }.join("\n")
  def content_table(q) = q[:content_blocks].find { |b| b[:type] == "table" }
  def median(values) = Rational(values.sort[(values.size - 1) / 2] + values.sort[values.size / 2], 2)

  def assert_answer(q, matches, id)
    assert_equal 1, matches.size, id
    assert_equal q[:choices].select { |c| c[:correct] }.map { |c| c[:label] }, matches.map { |c| c[:label] }, id
  end

  def correlation(x, y)
    dx, dy = [x, y].map { |v| v.map { |n| n - v.sum.to_f / v.size } }
    dx.zip(dy).sum { |a, b| a * b } / Math.sqrt(dx.sum { |v| v**2 } * dy.sum { |v| v**2 })
  end

  # These independent oracles do not execute the candidate marked correct.
  def purpose(exam, input, source)
    case exam
    when 41 then input.first(1) + input.each_cons(2).map { |a, b| b - a }
    when 42
      limit = source[/limit = (\d+)/, 1].to_i
      first = input.each_index.find { |i| input.first(i + 1).sum > limit }
      input.first(first || input.size).sum
    when 43 then input.each_index.find { |i| input[i].even? } || -1
    when 44 then input.each_index.count { |i| input[i] == 1 && (i.zero? || input[i - 1].zero?) }
    when 45 then input.select(&:positive?).sum
    when 46 then input.each_index.map { |i| input.drop(i).sum }
    when 47 then input.each_index.select { |i| input[i].positive? }.last || -1
    when 48 then input.each_cons(2).count { |a, b| a == b }
    when 49
      first = input.index { |x| x > source[/limit = (\d+)/, 1].to_i }
      first ? input.drop(first + 1).sum : 0
    when 50 then input.digits.sum
    end
  end

  # Reconstruct each actual correction instruction, not a label -> output map.
  def candidate(exam, source, choice)
    if exam == 42
      return choice[:content_blocks].first[:cells].each_with_index.reduce(source) { |code, (value, i)| code.sub("【#{%w[① ②][i]}】", value) }
    end
    text = choice_text(choice)
    return source.sub("【①】", text) if [41, 46].include?(exam)
    lines = source.lines.map(&:chomp)
    locate = ->(n) { lines.index { |line| line.start_with?(format("%02d ", n)) } || raise("missing line #{n}") }
    if exam == 45
      lines[locate.call(8)] = "08     #{text}"
    elsif text.include?("変更する")
      number = text[/\A(\d+)行/, 1].to_i
      value = text[/(?:条件を|行を) (.+?) に変更する/, 1] or raise "bad replacement #{text}"
      indent = lines[locate.call(number)][/\A\d+ ( *)/, 1]
      statement = text.include?("条件を") ? "if #{value}:" : value
      lines[locate.call(number)] = format("%02d ", number) + indent + statement
    elsif exam == 49
      block = [lines.delete_at(locate.call(6)), lines.delete_at(locate.call(7))]
      assert_includes text, "09行と10行の間"
      lines.insert(locate.call(10), *block)
    else
      number = text[/\A(\d+)行/, 1].to_i
      moved = lines.delete_at(locate.call(number))
      statement = moved.sub(/\A\d+ +/, "")
      unless text.include?("削除")
        if text.include?("一段浅く")
          destination, indent = exam == 43 ? [6, 4] : [7, 4]
        elsif (match = text.match(/(\d+)行の直前/))
          destination = match[1].to_i
          indent = lines[locate.call(destination)][/\A\d+ ( *)/, 1].size
        elsif text.include?("07行と08行の間")
          destination, indent = 8, 4
        elsif (match = text.match(/(\d+)行の直後/))
          after = match[1].to_i
          index = locate.call(after)
          indent = lines[index][/\A\d+ ( *)/, 1].size
          lines.insert(index + 1, format("%02d ", number) + " " * indent + statement)
          return lines.join("\n")
        else
          raise "unsupported movement #{text}"
        end
        lines.insert(locate.call(destination), format("%02d ", number) + " " * indent + statement)
      end
    end
    lines.join("\n")
  end

  def assert_algorithm_explanations(exam, q, runs)
    q[:choices].each do |choice|
      output = runs.fetch(choice[:label])[:output]
      text = q[:explanation_blocks].find { |b| b[:text]&.start_with?(choice[:label] + "：") }.fetch(:text)
      if output.is_a?(Array)
        assert_includes text, output.inspect
      elsif exam == 43 && choice[:correct]
        assert_includes text, "04行で#{output}を返す"
      else
        assert_match(/表示は#{Regexp.escape(output.to_s)}[。，]/, text, "#{exam}-19 #{choice[:label]}")
      end
    end
  end

  def assert_trace(exam, q, input, run)
    rows = run[:trace].map.with_index do |step, iteration|
      before, after = step.values_at(:before, :after)
      i = after["i"]
      case exam
      when 41 then [i, before["data"][i], before["data"][i - 1], after["data"][i]].map(&:to_s)
      when 42
        x, total = before.values_at("x", "total")
        [x.to_s, total.to_s, (total + x).to_s, step[:signal] == :break ? "加算せず反復を終了する" : "加算し，totalを#{after['total']}にする"]
      when 43 then [i.to_s, input[i].to_s, input[i].even? ? "偶数なので#{i}を返し，関数を終了する" : "奇数なので次の要素へ進む"]
      when 44 then [after["x"].to_s, before["prev"].to_s, after["groups"] > before["groups"] ? "増やす" : "増やさない", after["groups"].to_s]
      when 45 then [after["value"], before["total"], after["total"]].map(&:to_s)
      when 46 then [i.to_s, "#{before['data'][i]} + #{before['data'][i + 1]} = #{after['data'][i]}", after["data"].inspect]
      when 47 then [i, input[i], after["last"]].map(&:to_s)
      when 48 then [i, input[i], before["prev"], after["count"], after["prev"]].map(&:to_s)
      when 49 then [after["x"].to_s, before["started"].to_s, before["started"] == 1 ? after["x"].to_s : "加えない", after["total"].to_s, after["started"].to_s]
      when 50 then [iteration + 1, before["x"], before["x"] % 10, after["total"], after["x"]].map(&:to_s)
      end
    end
    assert_equal q[:explanation_blocks].find { |b| b[:type] == "table" }.fetch(:rows), rows, "#{exam}-19 intermediate trace"
  end

  # Restricted interpreter for only the displayed teaching-code operations.
  # It never evals seed strings as Ruby or shells out to Python. Statement
  # placement and indentation are parsed after applying each choice's edits.
  class Pseudocode
    def initialize(source)
      @lines = source.lines.map do |line|
        m = line.chomp.match(/\A\d+ ( *)(.+)\z/) or raise "bad code line"
        [m[1].size, m[2]]
      end
      @cursor = 0
      @tree = parse(0)
      raise "unparsed code" unless @cursor == @lines.size
      @environment, @functions, @trace = {}, {}, []
      @steps = 0
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
        node[:body] = parse(@lines[@cursor][0]) if @cursor < @lines.size && @lines[@cursor][0] > indent
        nodes << node
      end
      nodes
    end

    def execute(nodes)
      nodes.each do |node|
        @steps += 1
        raise "unexpected nontermination" if @steps > 10_000
        statement = node[:statement]
        signal = case statement
        when /\Adef (\w+)\(([^)]*)\):\z/
          @functions[Regexp.last_match(1)] = [Regexp.last_match(2).split(",").map(&:strip), node.fetch(:body)]
          nil
        when /\Aif (.+):\z/
          execute(node.fetch(:body)) if condition(Regexp.last_match(1))
        when /\Afor (\w+) in (.+):\z/
          variable, collection = Regexp.last_match.captures
          values = collection.start_with?("range(") ? range_values(collection) : expression(collection).dup
          iterate(variable, values, node.fetch(:body))
        when /\Awhile (.+):\z/
          test = Regexp.last_match(1)
          result = nil
          while condition(test)
            result = iteration(node.fetch(:body))
            break if result && [:break, :return].include?(result[0])
          end
          result if result && result[0] == :return
        when "break", "continue"
          [statement.to_sym, nil]
        when /\Areturn (.+)\z/
          [:return, expression(Regexp.last_match(1))]
        when /\Aprint\((.+)\)\z/
          @output = copy(expression(Regexp.last_match(1)))
          nil
        when /\A(data\[.+\]|\w+) = (.+)\z/
          target, raw = Regexp.last_match.captures
          value = expression(raw)
          if (m = target.match(/\Adata\[(.+)\]\z/))
            index = expression(m[1])
            raise "invalid index" unless index.between?(0, @environment.fetch("data").size - 1)
            @environment.fetch("data")[index] = value
          else
            @environment[target] = value
          end
          nil
        when /\A\w+\([^)]*\)\z/
          expression(statement)
          nil
        else
          raise "unsupported statement #{statement}"
        end
        return signal if signal
      end
      nil
    end

    def iterate(variable, values, body)
      values.each do |value|
        @environment[variable] = value
        signal = iteration(body)
        return signal if signal && signal[0] == :return
        break if signal && signal[0] == :break
      end
      nil
    end

    def iteration(body)
      before = snapshot
      signal = execute(body)
      @trace << { before: before, after: snapshot, signal: signal&.first }
      signal
    end

    def range_values(raw)
      args = raw.match(/\Arange\((.*)\)\z/)[1].split(",").map { |value| expression(value) }
      first, last, step = args
      step ||= 1
      raise "unsupported range step" unless [1, -1].include?(step)
      step == 1 ? (first...last).to_a : (first > last ? first.downto(last + 1).to_a : [])
    end

    def expression(raw)
      raw = raw.strip
      return raw.to_i if raw.match?(/\A-?\d+\z/)
      return JSON.parse(raw) if raw.match?(/\A\[[\d, \-]+\]\z/)
      # Split at the rightmost low-precedence operator outside parentheses/
      # brackets, preserving left-associativity and multiplication precedence.
      [/[+\-]/, /[%\/]/].each do |operators|
        depth = 0
        (raw.size - 1).downto(1) do |index|
          char = raw[index]
          depth += 1 if ["]", ")"].include?(char)
          depth -= 1 if ["[", "("].include?(char)
          next unless depth.zero? && char.match?(operators)
          next if char == "/" && raw[index - 1] == "/"
          operator = char == "/" ? "//" : char
          left, right = expression(raw[0...index]), expression(raw[(index + operator.size)..])
          return operator == "//" ? left.div(right) : left.public_send(operator, right)
        end
      end
      if (m = raw.match(/\Adata\[(.+)\]\z/))
        return @environment.fetch("data").fetch(expression(m[1]))
      end
      return expression(raw[/\Alen\((.+)\)\z/, 1]).size if raw.start_with?("len(")
      if (m = raw.match(/\A(\w+)\(([^)]*)\)\z/))
        name, arguments = m.captures
        parameters, body = @functions.fetch(name)
        arguments = arguments.split(",").map { |value| expression(value) }
        parent = @environment
        @environment = parameters.zip(arguments).to_h
        signal = execute(body)
        @environment = parent
        raise "function without return" unless signal && signal[0] == :return
        return signal[1]
      end
      @environment.fetch(raw)
    end

    def condition(raw)
      return raw.split(" and ").all? { |part| condition(part) } if raw.include?(" and ")
      m = raw.match(/\A(.+?)\s*(==|!=|<=|>=|>|<)\s*(.+)\z/) or raise "bad comparison #{raw}"
      expression(m[1]).public_send(m[2], expression(m[3]))
    end

    def copy(value) = value.is_a?(Array) ? value.dup : value
    def snapshot = @environment.transform_values { |value| copy(value) }
  end
end
