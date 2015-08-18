# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_reconnect_session'
if Rails.env.test? || Rails.env.development?
  Rails.application.config.session_store :active_record_store
else
  Rails.application.config.session_store ActionDispatch::Session::CacheStore
end
