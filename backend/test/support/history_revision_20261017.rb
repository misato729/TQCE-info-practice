# Historical approvals remain immutable. Only the 21 explicitly authorized
# history corrections may delegate their *old* snapshots to this revision.
# A changed current revision must fail here, not silently inherit an exemption.
require_relative "priority_revision_20261017"

module HistoryRevision20261017
  DATA = JSON.parse(File.read(Rails.root.join("test/fixtures/history_revision_20261017.json"))).freeze

  def self.historical_attributes(id, current)
    current = PriorityRevision20261017.historical_attributes(id, current)
    previous = DATA.fetch("previous_entries")[id]
    return current unless previous

    exam = id.split("-").first.to_i
    actual = QuestionPayload.digest(QuestionPayload.from_seed(exam, current))
    expected = DATA.fetch("revised_payload_digests").fetch(id)
    raise "#{id}: history revision changed; inspect the source and revision test" unless actual == expected

    previous.fetch("attributes").deep_symbolize_keys
  end

  def self.historical_payload_digest(id, exam, current)
    QuestionPayload.digest(QuestionPayload.from_seed(exam, historical_attributes(id, current)))
  end
end
