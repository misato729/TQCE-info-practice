# Preserve historical approval fixtures. Only the explicitly reviewed current
# payloads may delegate their old snapshots to this independently tested change.
module PriorityRevision20261017
  DATA = JSON.parse(File.read(Rails.root.join("test/fixtures/priority_revision_20261017.json"))).freeze

  def self.historical_attributes(id, current)
    previous = DATA.fetch("previous_entries")[id]
    return current unless previous

    actual = QuestionPayload.digest(QuestionPayload.from_seed(previous.fetch("exam_number"), current))
    expected = DATA.fetch("revised_payload_digests").fetch(id)
    raise "#{id}: priority revision changed; inspect the independent source tests" unless actual == expected

    previous.fetch("attributes").deep_symbolize_keys
  end

  def self.historical_payload_digest(id, exam, current)
    QuestionPayload.digest(QuestionPayload.from_seed(exam, historical_attributes(id, current)))
  end
end
