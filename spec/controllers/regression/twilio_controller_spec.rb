require 'rails_helper'

RSpec.describe TwilioController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/twilio/incoming_voice').to('twilio#incoming_voice', {}) } 
  it { should route(:post, '/twilio/incoming_sms').to('twilio#incoming_sms', {}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_paper_trail_enabled_for_controller) }
  it { should use_before_filter(:set_paper_trail_whodunnit) }
  it { should use_before_filter(:set_paper_trail_controller_info) }
  it { should use_before_filter(:additional_exception_data) }
  it { should use_before_filter(:set_staging) }
  it { should use_before_filter(:check_active) }
  it { should use_before_filter(:setup_accessibles) }
  it { should use_before_filter(:set_unseen_changelog_entries) }
  it { should use_before_filter(:log_additional_data) }
  it { should use_before_filter(:authorize_profiler) }
  it { should use_before_filter(:set_gateway) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:set_header) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end