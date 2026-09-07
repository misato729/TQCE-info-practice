# Partial, case-insensitive matching also covers password_confirmation,
# current_password, access_token, and HTTP_AUTHORIZATION in filtered_env.
Rails.application.config.filter_parameters += %i[
  password token secret api_key authorization cookie
]
