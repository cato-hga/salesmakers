require 'rails_helper'

RSpec.describe MinuteWorxPunchReceiverController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/minuteworx_punch/begin').to('minute_worx_punch_receiver#begin', {}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_paper_trail_enabled_for_controller) }
  it { should use_before_filter(:set_paper_trail_whodunnit) }
  it { should use_before_filter(:set_paper_trail_controller_info) }
  it { should use_before_filter(:additional_exception_data) }
  it { should use_before_filter(:set_staging) }
  it { should use_before_filter(:set_unseen_changelog_entries) }
  it { should use_before_filter(:log_additional_data) }
  it { should use_before_filter(:authorize_profiler) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end