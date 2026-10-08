module UserPayload
  module_function

  def call(user)
    membership = user.membership
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      paid_content_access: user.paid_content_access?,
      membership: {
        status: membership&.status || "free",
        purchased_at: membership&.activated_at&.iso8601,
        expires_at: nil,
      },
      created_at: user.created_at.iso8601,
    }
  end
end
