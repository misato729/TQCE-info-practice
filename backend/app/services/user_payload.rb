module UserPayload
  module_function

  def call(user)
    membership = user.membership
    verification_grant = user.verification_access_grant
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      paid_content_access: user.paid_content_access?,
      favorite_questions: favorite_questions(user),
      membership: {
        status: membership&.status || "free",
        purchased_at: membership&.activated_at&.iso8601,
        expires_at: nil,
      },
      verification_access: verification_grant&.active? ? { expires_at: verification_grant.expires_at.iso8601 } : nil,
      created_at: user.created_at.iso8601,
    }
  end

  def favorite_questions(user)
    return [] unless user.paid_content_access?

    user.favorites.joins(:question).merge(Question.published)
      .order("questions.exam_number", "questions.question_number")
      .pluck("questions.id", "questions.exam_number", "questions.question_number")
      .map { |id, exam_number, question_number| { id: id, exam_number: exam_number, question_number: question_number } }
  end
end
