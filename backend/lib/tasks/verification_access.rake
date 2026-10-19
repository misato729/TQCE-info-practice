namespace :verification_access do
  desc "Grant up to seven days of verification access to an existing user (no payment)"
  task grant: :environment do
    user = User.find_by!(email: ENV.fetch("USER_EMAIL").strip.downcase)
    abort "Administrators already have access" if user.role == "admin"
    expires_at = Time.iso8601(ENV.fetch("EXPIRES_AT"))
    grant = VerificationAccessGrant.create!(
      user: user,
      reason: ENV.fetch("REASON"),
      granted_by: ENV.fetch("GRANTED_BY"),
      expires_at: expires_at,
    )
    puts({ user_id: user.id, grant_id: grant.id, expires_at: grant.expires_at.iso8601 }.to_json)
  end

  desc "Revoke verification access without changing paid membership or account roles"
  task revoke: :environment do
    user = User.find_by!(email: ENV.fetch("USER_EMAIL").strip.downcase)
    grant = user.verification_access_grant || abort("No verification grant exists")
    grant.update!(revoked_at: Time.current) unless grant.revoked_at
    puts({ user_id: user.id, grant_id: grant.id, revoked: true }.to_json)
  end
end
