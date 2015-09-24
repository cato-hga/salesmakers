require 'rails_helper'

RSpec.describe ComcastCustomersController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/comcast_customers').to('comcast_customers#index', {}) }
  it { should route(:get, '/comcast_customers/1').to('comcast_customers#show', {:id=>"1"}) }
  it { should route(:get, '/comcast_customers/new').to('comcast_customers#new', {}) }
  it { should route(:post, '/comcast_customers').to('comcast_customers#create', {}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
  it { should use_before_filter(:set_ahoy_cookies) }
  it { should use_before_filter(:track_ahoy_visit) }
  it { should use_before_filter(:set_paper_trail_enabled_for_controller) }
  it { should use_before_filter(:set_paper_trail_whodunnit) }
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
  it { should use_before_filter(:set_comcast_locations) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end