require 'rails_helper'

RSpec.describe VonageDevicesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/vonage_devices/accept').to('vonage_devices#accept', {}) }
  it { should route(:post, '/vonage_devices').to('vonage_devices#create', {}) } 
  it { should route(:post, '/vonage_devices/do_accept').to('vonage_devices#do_accept', {}) } 
  it { should route(:post, '/vonage_devices/do_reclaim').to('vonage_devices#do_reclaim', {}) } 
  it { should route(:post, '/vonage_devices/do_transfer').to('vonage_devices#do_transfer', {}) } 
  it { should route(:get, '/vonage_devices/employees_reclaim').to('vonage_devices#employees_reclaim', {}) }
  it { should route(:get, '/vonage_devices').to('vonage_devices#index', {}) }
  it { should route(:get, '/vonage_devices/new').to('vonage_devices#new', {}) }
  it { should route(:get, '/vonage_devices/reclaim').to('vonage_devices#reclaim', {}) }
  it { should route(:get, '/vonage_devices/transfer').to('vonage_devices#transfer', {}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
  it { should use_before_filter(:set_ahoy_cookies) }
  it { should use_before_filter(:track_ahoy_visit) }
  it { should use_before_filter(:set_paper_trail_enabled_for_controller) }
  it { should use_before_filter(:set_paper_trail_controller_info) }
  it { should use_before_filter(:additional_exception_data) }
  it { should use_before_filter(:set_staging) }
  it { should use_before_filter(CASClient::Frameworks::Rails::Filter) }
  it { should use_before_filter(:set_current_user) }
  it { should use_before_filter(:check_active) }
  it { should use_before_filter(:record_action_event) }
  it { should use_before_filter(:setup_accessibles) }
  it { should use_before_filter(:set_unseen_changelog_entries) }
  it { should use_before_filter(:log_additional_data) }
  it { should use_before_filter(:authorize_profiler) }
  it { should use_before_filter(:do_authorization) }
  it { should use_before_filter(:chronic_time_zones) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end