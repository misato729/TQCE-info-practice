class CreateVerificationAccessGrants < ActiveRecord::Migration[7.1]
  def change
    create_table :verification_access_grants do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: { unique: true }
      t.string :reason, limit: 255, null: false
      t.string :granted_by, limit: 100, null: false
      t.datetime :expires_at, null: false
      t.datetime :revoked_at
      t.timestamps
    end

    add_check_constraint :verification_access_grants,
      "expires_at > created_at AND expires_at <= created_at + interval '7 days'",
      name: "verification_access_grants_limited_duration"
    add_check_constraint :verification_access_grants,
      "char_length(btrim(reason)) > 0 AND char_length(btrim(granted_by)) > 0",
      name: "verification_access_grants_audit_required"
  end
end
