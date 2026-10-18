# A later review must not rewrite earlier approval or source fixtures. Only
# these exact revised payloads (or their exact captured baseline, when an older
# test has already unwrapped them) may delegate to historical comparisons.
module FinalReview20261018
  DATA = JSON.parse(File.read(Rails.root.join("test/fixtures/final_review_20261018.json"))).freeze

  def self.historical_attributes(id, current)
    previous = DATA.fetch("previous_entries")[id]
    return current unless previous

    actual = QuestionPayload.digest(QuestionPayload.from_seed(previous.fetch("exam_number"), current))
    return current if actual == DATA.fetch("previous_payload_digests").fetch(id)
    unless actual == DATA.fetch("revised_payload_digests").fetch(id)
      raise "#{id}: final review changed; inspect its independent revision and source tests"
    end

    previous.fetch("attributes").deep_symbolize_keys
  end

  def self.historical_entry(entry)
    id = "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
    entry.merge(attributes: historical_attributes(id, entry.fetch(:attributes)))
  end
end
