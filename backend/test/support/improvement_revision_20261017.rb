# This later, explicitly requested review never rebases older approval fixtures.
# Only the fixed revised payload may delegate to its independently captured past.
require_relative "final_review_20261018"

module ImprovementRevision20261017
  DATA = JSON.parse(File.read(Rails.root.join("test/fixtures/improvement_revision_20261017.json"))).freeze

  def self.historical_attributes(id, current)
    current = FinalReview20261018.historical_attributes(id, current)
    previous = DATA.fetch("previous_entries")[id]
    return current unless previous

    actual = QuestionPayload.digest(QuestionPayload.from_seed(previous.fetch("exam_number"), current))
    expected = DATA.fetch("revised_payload_digests").fetch(id)
    raise "#{id}: improvement revision changed; inspect its independent checks" unless actual == expected

    previous.fetch("attributes").deep_symbolize_keys
  end

  def self.historical_entry(entry)
    id = "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
    entry.merge(attributes: historical_attributes(id, entry.fetch(:attributes)))
  end
end
