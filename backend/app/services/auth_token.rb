class AuthToken
  EXPIRES_IN = 24.hours

  class << self
    def issue(user)
      verifier.generate(
        { user_id: user.id, role: user.role },
        expires_in: EXPIRES_IN,
        purpose: :access_token,
      )
    end

    def verify(token)
      verifier.verified(token, purpose: :access_token)&.with_indifferent_access
    end

    private

    def verifier
      @verifier ||= ActiveSupport::MessageVerifier.new(
        Rails.application.secret_key_base,
        digest: "SHA256",
        serializer: JSON,
      )
    end
  end
end
