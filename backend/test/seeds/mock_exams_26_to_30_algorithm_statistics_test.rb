require "test_helper"
require "digest"

class MockExams26To30AlgorithmStatisticsTest < ActionDispatch::IntegrationTest
  EXAMS = (26..30).to_a.freeze
  NUMBERS = [19, 20].freeze
  PARTIAL_NUMBERS = ((3..15).to_a + NUMBERS).freeze
  LABELS = %w[ア イ ウ エ].freeze
  ANSWERS = { 26 => %w[エ ア], 27 => %w[イ ウ], 28 => %w[ウ ア], 29 => %w[ウ エ], 30 => %w[ア イ] }.freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_approved_algorithm_statistics_drafts.json"))).freeze

  setup do
    @entries = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
    @added = @entries.select { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }
    @questions = @added.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認十問の本文コード入力表四択正答全解説出典をseed非依存snapshotと照合する" do
    assert_equal 75, @entries.size
    assert_equal 10, @added.size
    assert_equal APPROVED.fetch("sections").keys.sort, @questions.keys.sort
    assert_match(/\A[0-9a-f]{64}\z/, APPROVED.fetch("sha256"))
    @added.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      draft = APPROVED.fetch("sections").fetch(id)
      head, tail = draft.split(/^正答：[アイウエ].*$/, 2)
      choice_start = head.index(/^\| 選択肢 \|/) || head.index(/^[アイウエ]　/)
      assert choice_start, "#{id} 草案の選択肢境界"
      assert_equal "draft", entry.fetch(:publication_status), id
      assert_equal "information", question.fetch(:major_category_code), id
      assert_equal "information_specialized", question.fetch(:category_code), id
      assert_equal draft[/^正答：([アイウエ])/, 1], answer(question).fetch(:label), id
      assert_blocks_match markdown_blocks(head[0...choice_start]), question[:content_blocks], id
      if head[choice_start..].start_with?("| 選択肢 |")
        rows = head[choice_start..].lines.grep(/^\| [アイウエ] \|/).map { |line| markdown_row(line) }
        assert_equal rows, question[:choices].map { |choice| [choice[:label], *choice_cells(choice)] }, id
        assert question[:choices].all? { |choice| choice[:content_blocks].size == 1 }, id
        question[:choices].map { |choice| choice_cells(choice) }.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort, id }
      else
        pairs = head[choice_start..].scan(/^([アイウエ])　([^\n]+)/).map { |label, text| [label, normalize(text)] }
        assert_equal pairs, question[:choices].map { |choice| [choice[:label], normalize(choice[:content_blocks].first.fetch(:text))] }, id
        assert question[:choices].all? { |choice| choice[:content_blocks].size == 1 && choice[:content_blocks].first[:type] == "text" }, id
      end
      explanation, sources = tail.split(/^参考出典：/, 2)
      # Only Markdown's explanation prefix and bullet markers are converted.
      expected_explanation = explanation.strip.sub(/\A解説：/, "").gsub(/^- ([アイウエ]：)/, '\\1')
      assert_blocks_match markdown_blocks(expected_explanation), question[:explanation_blocks], id
      expected_sources = sources.split(/^source_text：/, 2).last.lines.map(&:strip).reject(&:empty?).join("\n")
      assert_equal expected_sources, question.fetch(:source_text), id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      assert_equal LABELS, question[:choices].map { |choice| choice[:label] }, id
      assert_equal 1, question[:choices].count { |choice| choice[:correct] }, id
      assert_equal LABELS, question[:explanation_blocks].filter_map { |block| block[:type] == "text" && block[:text][/\A([アイウエ])：/, 1] }, id
      preview = QuestionSeedSync.preview(entry)
      # Writer choice keys are symbols but nested content_blocks stay in the
      # API's string-keyed representation; do not symbolize those recursively.
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal PARTIAL_NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ANSWERS.fetch(exam), entries.last(2).map { |entry| answer(entry[:attributes])[:label] }, exam
      assert entries.map { |entry| answer(entry[:attributes])[:label] }.tally.values.all? { |count| count <= 5 }, exam
    end
    assert_equal ["29-20"], @questions.select { |_id, question| question[:content_blocks].first[:text].include?("適切でないもの") }.keys
  end

  test "既存五十問と新規十問の本文及び選択肢に完全重複がない" do
    existing = QuestionSeedSync.collect { (1..25).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
      .select { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }
    assert_equal 50, existing.size
    fingerprints = (existing + @added).map do |entry|
      attributes = entry.fetch(:attributes)
      normalize([attributes.fetch(:content_blocks), attributes.fetch(:choices).map { |choice| choice.fetch(:content_blocks) }].to_json)
    end
    assert_equal 60, fingerprints.uniq.size
  end

  test "コードの二空欄と二列は整合し必須空欄全消去及びセル不足を拒否する" do
    [26, 27].each do |exam|
      question = @questions.fetch("#{exam}-19")
      assert_equal "fill_in_text", question[:content_blocks].first[:type]
      assert_equal %w[① ②], question[:content_blocks].first[:text].scan(/\{\{([①②])\}\}/).flatten.uniq
      assert_equal %w[① ②], code(exam).scan(/【([①②])】/).flatten.uniq
      question[:choices].each { |choice| assert_equal "fill_in_choice", choice[:content_blocks].first[:type]; assert_equal 2, choice_cells(choice).size }
      path = Rails.root.join("db/seeds/mock_exam_#{exam}.rb")
      source = File.read(path)
      mutations = [
        "questions.find { |question| question[:question_number] == 19 }[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][①②][}][}]/, '語句') if block[:type] == 'fill_in_text'; block[:code] = block[:code].gsub(/【[①②]】/, '語句') if block[:type] == 'code' }\n",
        "questions.find { |question| question[:question_number] == 19 }[:choices].first[:content_blocks].first[:cells].pop\n",
      ]
      assert_includes source, "questions.each do |question|\n"
      mutations.each do |mutation|
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
          assert_raises(RuntimeError, ActiveRecord::RecordInvalid) do
            QuestionSeedSync.collect { eval(source.sub("questions.each do |question|\n", mutation + "questions.each do |question|\n"), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "模試二十六の表示コード四候補を目的から独立計算し全誤答出力を照合する" do
    lines = program(26)
    assert_equal "if x % 2 【①】 0:", lines[3].strip
    assert_equal "x = x // 2", lines[4].strip
    assert_equal "【②】 x % 2 == 1:", lines[5].strip
    assert_equal "x = 3 * x + 1", lines[6].strip
    data = array_assignment(lines[0], "data")
    expected = data.map { |value| value.even? ? value / 2 : value * 3 + 1 }
    matches = @questions.fetch("26-19")[:choices].count do |choice|
      comparison, branch = choice_cells(choice)
      assert_includes %w[== !=], comparison
      assert_includes %w[if elif], branch
      output = data.map do |value|
        first = comparison == "==" ? value.even? : value.odd?
        x = first ? value / 2 : value
        x = 3 * x + 1 if (branch == "if" || !first) && x.odd?
        x
      end
      valid = output == expected
      assert_equal choice[:correct], valid, choice[:label]
      assert_equal output, JSON.parse(explanation("26-19", choice[:label])[/\[[0-9, ]+\]/]), choice[:label]
      valid
    end
    assert_equal 1, matches
    assert_equal data.zip(expected).map { |value, result| [value.to_s, value.even? ? "2で割る" : "3倍して1を加える", result.to_s] }, explanation_table("26-19")[:rows]
  end

  test "模試二十七の旧値退避を全四候補で実行し十二及び誤答二十十一を検算する" do
    lines = program(27)
    assert_equal "t = 【①】", lines[3].strip
    assert_equal "x = x + y", lines[4].strip
    assert_equal "y = 【②】", lines[5].strip
    x0, y0 = integer_assignment(lines[0], "x"), integer_assignment(lines[1], "y")
    count = lines[2][/range\(0, (\d+)\)/, 1].to_i
    expected = count.times.reduce([x0, y0]) { |(x, y), _| [x + y, x] }.first
    matches = @questions.fetch("27-19")[:choices].count do |choice|
      old, update = choice_cells(choice)
      x, y, rows = x0, y0, []
      count.times do |iteration|
        before_x, before_y = x, y
        t = { "x" => x, "y" => y }.fetch(old)
        x += y
        y = { "x" => x, "t" => t }.fetch(update)
        rows << ["#{iteration + 1}回目", "#{before_x}，#{before_y}", t.to_s, "#{x}，#{y}"]
      end
      valid = x == expected
      assert_equal choice[:correct], valid, choice[:label]
      assert_equal x, explanation("27-19", choice[:label])[/表示は(\d+)となる/, 1].to_i, choice[:label]
      assert_equal rows, explanation_table("27-19")[:rows] if valid
      valid
    end
    assert_equal 1, matches
    assert_equal 12, expected
  end

  test "模試二十八の表示コードを全四修正で追跡し印字回数も区別する" do
    lines = program(28)
    assert_equal "total = total + x", lines[3].strip
    assert_equal "total = total // 5", lines[4].strip
    data = array_assignment(lines[0], "data")
    divisor = lines[4][/\/\/ (\d+)/, 1].to_i
    expected = [data.sum / data.size]
    outputs = {}
    total, outputs["ア"] = 0, []
    data.each { |value| total = (total + value) / divisor; outputs["ア"] << total }
    outputs["イ"] = [0 / divisor + data.sum]
    outputs["ウ"] = [data.sum / divisor]
    total, trace = 0, []
    data.each { |value| total = total / divisor + value; trace << total }
    outputs["エ"] = [total]
    assert_equal [3, 8, 5, 7, 10], trace
    assert_equal 1, @questions.fetch("28-19")[:choices].count { |choice| valid = outputs.fetch(choice[:label]) == expected; assert_equal choice[:correct], valid; valid }
    assert_equal [0, 1, 1, 1, 2], outputs["ア"]
    outputs.each do |label, values|
      text = explanation("28-19", label)
      if label == "ア"
        assert_includes text, values.join("，")
      elsif label == "ウ"
        assert_includes text, "#{values.first}を表示する"
      else
        assert_match(/表示は.*?#{values.first}/, text)
      end
    end
    assert_includes @questions.fetch("28-19")[:explanation_blocks].find { |block| block[:type] == "code" }[:code], "3 → 11 → 15 → 21 → 30"
  end

  test "模試二十九の六入力の状態更新と誤答三モデルを全実行する" do
    lines = program(29)
    assert_equal "if signal == 1:", lines[4].strip
    assert_equal "on = not on", lines[5].strip
    assert_equal "if on:", lines[7].strip
    data = array_assignment(lines[0], "signals")
    state, count, rows, restricted, before_count = false, 0, [], 0, 0
    data.each do |signal|
      before_count += 1 if state
      state = !state if signal == 1
      count += 1 if state
      restricted += 1 if signal == 1 && state
      rows << [signal.to_s, state ? "真" : "偽", count.to_s]
    end
    outputs = { "ア" => restricted, "イ" => data.count(1), "ウ" => count, "エ" => before_count }
    assert_equal 5, count
    assert_equal rows, explanation_table("29-19")[:rows]
    @questions.fetch("29-19")[:choices].each do |choice|
      value = choice[:content_blocks].first[:text].to_i
      assert_equal outputs.fetch(choice[:label]), value
      assert_equal choice[:correct], value == count
      assert_includes explanation("29-19", choice[:label]), choice[:correct] ? "計#{value}回" : "#{value}は"
    end
    assert_includes explanation("29-19", "イ"), "on = (signal == 1)"
    assert_includes explanation("29-19", "エ"), "切替え前"
  end

  test "模試三十の間接書込みを全候補で実行し配列と解説の途中表を照合する" do
    lines = program(30)
    assert_equal "out[dest[i]] = data[i]", lines[4].strip
    data, dest = array_assignment(lines[0], "data"), array_assignment(lines[1], "dest")
    out = array_assignment(lines[2], "out")
    rows = []
    data.each_index { |i| out[dest[i]] = data[i]; rows << [i.to_s, data[i].to_s, dest[i].to_s, "out[#{dest[i]}] = #{data[i]}"] }
    wrong_read = dest.map { |index| data.fetch(index) }
    reverse = Array.new(out.size)
    data.each_index { |i| reverse[out.size - 1 - dest[i]] = data[i] }
    outputs = { "ア" => out, "イ" => wrong_read, "ウ" => data, "エ" => reverse }
    assert_equal rows, explanation_table("30-19")[:rows]
    assert_equal [9, 2, 5, 4, 7], out
    @questions.fetch("30-19")[:choices].each do |choice|
      output = JSON.parse(choice[:content_blocks].first[:text])
      assert_equal outputs.fetch(choice[:label]), output
      assert_equal choice[:correct], output == out
    end
    assert_includes explanation("30-19", "イ"), "out[i] = data[dest[i]]"
    assert_includes explanation("30-19", "エ"), "out[4 - dest[i]] = data[i]"
  end

  test "人口千人当たりを表示二市の入力から分数で検算し四肢の誤りも確認する" do
    question = @questions.fetch("26-20")
    rows = question[:content_blocks].find { |block| block[:type] == "table" }[:rows]
    expected = rows.map { |_city, population, incidents| Rational(incidents.delete(",").to_i, population.delete(",").to_i) * 1000 }
    assert_equal [Rational(2), Rational(3, 2)], expected
    question[:choices].each do |choice|
      values = choice_cells(choice).map { |value| Rational(value) }
      assert_equal choice[:correct], values == expected
      wrong_columns = values.zip(expected).filter_map { |actual, correct| actual / correct unless actual == correct }
      assert wrong_columns.all? { |ratio| ratio == Rational(1, 10) }
    end
    assert_operator rows[1][2].to_i, :>, rows[0][2].to_i
    assert_operator expected.first, :>, expected.last
  end

  test "時系列は同じ対象の異時点横断は同時点の異対象で観測対応を保持する" do
    question = @questions.fetch("27-20")
    text = question[:content_blocks].map { |block| block[:text] }.join
    assert_includes text, "2024年1月から2025年12月"
    assert_includes text, "一つの図書館"
    assert_includes text, "40の図書館"
    assert_includes text, "2025年12月"
    assert_equal "ウ", answer(question)[:label]
    months = (0...24).map { |i| [2024 + i / 12, i % 12 + 1] }
    assert_equal [2024, 1], months.first
    assert_equal [2025, 12], months.last
    # A counterexample makes the sorting error independently falsifiable.
    visitors = [20, 40, 10]
    assert_equal [20, -30], visitors.each_cons(2).map { |a, b| b - a }
    assert_equal [10, 20], visitors.sort.each_cons(2).map { |a, b| b - a }
    assert_includes explanation("27-20", "ア"), "年月"
    assert_includes explanation("27-20", "イ"), "分類が逆"
    assert_includes explanation("27-20", "エ"), "時間的変化"
  end

  test "水準化の境界と情報損失平均と人数合計の取り違えを表示四値から検算する" do
    question = @questions.fetch("28-20")
    tables = question[:content_blocks].select { |block| block[:type] == "table" }
    assert_equal 2, tables.size
    times = tables.last[:rows][0].drop(1).map(&:to_i)
    recorded = tables.last[:rows][1].drop(1).map(&:to_i)
    level = ->(minutes) { minutes < 30 ? 1 : minutes < 60 ? 2 : 3 }
    assert_equal recorded, times.map(&level)
    assert_equal [1, 1, 2, 2, 3, 3], [0, 29, 30, 59, 60, 90].map(&level)
    assert_equal Rational(195, 4), Rational(times.sum, times.size)
    assert_equal 2, Rational(recorded.sum, recorded.size)
    assert_not_equal Rational(45), Rational(times.sum, times.size)
    assert_equal recorded[1], recorded[2]
    assert_equal 25, times[2] - times[1]
    grouped = times.zip(recorded).group_by(&:last)
    assert_equal 2, Rational(grouped.fetch(2).size, grouped.fetch(1).size)
    assert_equal [85, 20], [2, 1].map { |group| grouped.fetch(group).sum(&:first) }
    assert_not_equal 2, Rational(grouped.fetch(2).sum(&:first), grouped.fetch(1).sum(&:first))
    assert_equal "ア", answer(question)[:label]
  end

  test "二変量の行整列と独立した列整列を全四組及び相関方向で検算する" do
    question = @questions.fetch("29-20")
    rows = question[:content_blocks].find { |block| block[:type] == "table" }[:rows]
    pairs = rows.map { |_student, x, y| [x.to_i, y.to_i] }
    sorted_rows = pairs.sort_by(&:first)
    independently_sorted = pairs.map(&:first).sort.zip(pairs.map(&:last).sort)
    assert_equal [[10, 80], [20, 70], [30, 60], [40, 50]], sorted_rows
    assert_equal [[10, 50], [20, 60], [30, 70], [40, 80]], independently_sorted
    assert_equal pairs.sort, sorted_rows.sort
    assert_not_equal pairs.sort, independently_sorted.sort
    assert_in_delta(-1, correlation(pairs), 1e-12)
    assert_in_delta(-1, correlation(pairs.map { |x, y| [x.fdiv(60), y] }), 1e-12)
    assert_in_delta(1, correlation(independently_sorted), 1e-12)
    assert_equal "エ", answer(question)[:label]
    assert_equal pairs.map(&:first).sort, independently_sorted.map(&:first)
    assert_equal pairs.map(&:last).sort, independently_sorted.map(&:last)
    explanation_rows = explanation_table("29-20")[:rows]
    [sorted_rows, independently_sorted].zip(explanation_rows).each do |expected, row|
      assert_equal expected, row.last.scan(/（(\d+)，(\d+)）/).map { |pair| pair.map(&:to_i) }
    end
  end

  test "二倍変換の平均分散標準偏差及び全四組の正答一意性を検算する" do
    question = @questions.fetch("30-20")
    rows = question[:content_blocks].find { |block| block[:type] == "table" }[:rows]
    a, b = rows.map { |_name, values| values.split("，").map(&:to_i) }
    assert_equal a.map { |value| value * 2 }, b
    stats = [a, b].map { |values| [mean(values), variance(values), Math.sqrt(variance(values))] }
    assert_equal [[3, 1, 1], [6, 4, 2]], stats
    expected = stats[1].zip(stats[0]).map { |second, first| second / first }
    assert_equal [2, 4, 2], expected
    assert_equal 1, question[:choices].count { |choice| valid = choice_cells(choice).map(&:to_i) == expected; assert_equal choice[:correct], valid; valid }
    explanation_table("30-20")[:rows].zip(stats).each do |row, calculated|
      assert_equal calculated, row.values_at(1, 4, 5).map(&:to_f)
    end
  end

  test "新規十問は管理確認のみ可能で一覧next一般取得回答に公開しない" do
    save_entries
    assert_equal 75, Question.where(exam_number: EXAMS, publication_status: "draft").count
    [nil, admin_headers].each do |headers|
      get api_v1_exams_path, headers: headers
      assert_response :success
      assert_empty response.parsed_body.fetch("data").map { |exam| exam.fetch("exam_number") } & EXAMS
    end
    EXAMS.each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: 18 }, headers: admin_headers
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
      get "/api/v1/admin/questions", params: { exam_number: exam, publication_status: "draft" }, headers: admin_headers
      assert_response :success
      assert_equal 15, response.parsed_body.dig("meta", "total_count")
      assert_equal PARTIAL_NUMBERS, response.parsed_body.fetch("data").map { |record| record.fetch("question_number") }
    end
    @added.each do |entry|
      record = record_for(entry)
      get "/api/v1/admin/questions/#{record.id}", headers: admin_headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal "draft", data.fetch("publication_status")
      assert_equal record.content_blocks, data.fetch("content_blocks")
      assert_equal record.explanation_blocks, data.fetch("explanation_blocks")
      assert_equal record.source_text, data.fetch("source_text")
      assert_equal 1, data.fetch("choices").count { |choice| choice.fetch("is_correct") }
      [nil, admin_headers].each do |headers|
        get api_v1_question_path(record), headers: headers
        assert_response :not_found
        assert_no_public_answers(response.parsed_body)
        assert_no_difference "AnswerHistory.count" do
          post answer_api_v1_question_path(record), params: { selected_choice_id: record.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
        end
        assert_response :not_found
        assert_no_public_answers(response.parsed_body)
      end
    end
  end

  test "テスト内だけ公開して回答前秘匿及び回答後全解説出典を検査する" do
    save_entries
    @added.each do |entry|
      record = record_for(entry)
      record.update!(publication_status: "published")
      get api_v1_question_path(record), headers: admin_headers
      assert_response :success
      assert_equal record.content_blocks, response.parsed_body.dig("data", "content_blocks")
      assert_no_public_answers(response.parsed_body)
      correct = record.question_choices.find_by!(is_correct: true)
      assert_difference "AnswerHistory.count", 1 do
        post answer_api_v1_question_path(record), params: { selected_choice_id: correct.id }, headers: admin_headers, as: :json
      end
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct")
      assert_equal correct.choice_label, response.parsed_body.dig("data", "correct_choice", "choice_label")
      assert_equal record.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal record.source_text, response.parsed_body.dig("data", "source_text")
    end
  end

  test "二回再同期で既存と新規のID内容履歴お気に入りseed状態を保持する" do
    save_entries
    load Rails.root.join("db/seeds/mock_exam_1.rb")
    user = User.create!(name: "アルゴリズム統計再同期確認", email: "mock26-information-reseed@example.com", password: "password123", password_confirmation: "password123")
    [[1, 19], [26, 3], [26, 19], [28, 20], [30, 20]].each do |exam, number|
      record = Question.find_by!(exam_number: exam, question_number: number)
      user.answer_histories.create!(question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
      user.favorites.create!(question: record)
    end
    before = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        save_entries
      end
      assert_equal before, snapshot
    end
  end

  test "十五問の未完セットは不足する問一二十六十七十八を示して公開拒否する" do
    save_entries
    EXAMS.each do |exam|
      record = Question.find_by!(exam_number: exam, question_number: 19)
      before = snapshot
      patch "/api/v1/admin/questions/#{record.id}", params: { question: QuestionPayload.from_record(record).merge("publication_status" => "published") }, headers: admin_headers, as: :json
      assert_response :unprocessable_content
      error = response.parsed_body.dig("error", "message")
      assert_includes error, "問1〜20の登録が必要"
      [1, 2, 16, 17, 18].each { |number| assert_match(/問#{number}(?:、|\z)/, error) }
      assert_equal "draft", record.reload.publication_status
      assert_equal before, snapshot
    end
  end

  private

  def key(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def answer(question)
    question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def choice_cells(choice)
    block = choice.fetch(:content_blocks).first
    block[:type] == "table" ? block.fetch(:rows).first : block.fetch(:cells)
  end

  def markdown_row(line)
    line.strip.split("|", -1)[1...-1].map(&:strip)
  end

  def normalize(text)
    text.to_s.delete("`").gsub(/\{\{([①②])\}\}|【([①②])】/) { Regexp.last_match(1) || Regexp.last_match(2) }.gsub(/[[:space:]　]+/, "")
  end

  def markdown_blocks(text)
    lines, blocks = text.strip.lines.map(&:chomp), []
    until lines.empty?
      line = lines.shift
      next if line.strip.empty?
      if line.start_with?("```")
        code = []
        code << lines.shift until lines.empty? || lines.first.start_with?("```")
        assert lines.shift&.start_with?("```"), "閉じるコード境界"
        blocks << { type: "code", code: code.join("\n") }
      elsif line.start_with?("|")
        headers, rows = markdown_row(line), []
        until lines.empty? || !lines.first.start_with?("|")
          current = lines.shift
          rows << markdown_row(current) unless current.match?(/\A\|[\s:|\-]+\|\z/)
        end
        blocks << { type: "table", headers: headers, rows: rows }
      else
        paragraph = [line]
        paragraph << lines.shift until lines.empty? || lines.first.strip.empty? || lines.first.start_with?("|", "```") || lines.first.match?(/\A[アイウエ]：/)
        blocks << { type: "text", text: paragraph.join("\n") }
      end
    end
    blocks
  end

  def assert_blocks_match(expected, actual, id)
    assert_equal expected.size, actual.size, id
    expected.zip(actual).each do |draft, block|
      if draft[:type] == "text"
        assert_includes %w[text fill_in_text], block.fetch(:type), id
        assert_equal normalize(draft[:text]), normalize(block.fetch(:text)), id
      elsif draft[:type] == "code"
        assert_equal "code", block.fetch(:type), id
        assert_equal draft[:code], block.fetch(:code).strip, id
      else
        assert_equal "table", block.fetch(:type), id
        assert_equal draft[:headers], block.fetch(:headers), id
        assert_equal draft[:rows], block.fetch(:rows), id
      end
    end
  end

  def code(exam)
    @questions.fetch("#{exam}-19")[:content_blocks].find { |block| block[:type] == "code" }.fetch(:code)
  end

  def program(exam)
    code(exam).lines.map { |line| line.chomp.sub(/\A\d{2}(?: |$)/, "") }
  end

  def array_assignment(line, variable)
    JSON.parse(line.match(/\A#{Regexp.escape(variable)} = (\[[0-9, ]*\])\z/)[1])
  end

  def integer_assignment(line, variable)
    line.match(/\A#{Regexp.escape(variable)} = (\d+)\z/)[1].to_i
  end

  def explanation(id, label)
    @questions.fetch(id)[:explanation_blocks].find { |block| block[:type] == "text" && block[:text].start_with?("#{label}：") }.fetch(:text)
  end

  def explanation_table(id)
    @questions.fetch(id)[:explanation_blocks].find { |block| block[:type] == "table" }
  end

  def mean(values)
    values.sum.fdiv(values.size)
  end

  def variance(values)
    average = mean(values)
    mean(values.map { |value| (value - average)**2 })
  end

  def correlation(pairs)
    x, y = pairs.transpose
    mx, my = mean(x), mean(y)
    pairs.sum { |a, b| (a - mx) * (b - my) } / Math.sqrt(x.sum { |value| (value - mx)**2 } * y.sum { |value| (value - my)**2 })
  end

  def save_entries
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def record_for(entry)
    Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
  end

  def admin_headers
    @admin_headers ||= begin
      admin = User.create!(name: "アルゴリズム統計管理確認", email: "mock26-information-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
      { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    end
  end

  def assert_no_public_answers(value)
    case value
    when Hash
      assert_empty value.keys & %w[is_correct correct_choice explanation_blocks source_text]
      value.each_value { |child| assert_no_public_answers(child) }
    when Array
      value.each { |child| assert_no_public_answers(child) }
    end
  end

  def snapshot
    [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
  end
end
