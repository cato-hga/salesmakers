require 'rails_helper'

RSpec.describe LinesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:patch, '/lines/1/activate').to('lines#activate', {:id=>"1"}) } 
  it { should route(:patch, '/lines/1/add_state').to('lines#add_state', {:id=>"1"}) } 
  it { should route(:post, '/lines').to('lines#create', {}) } 
  it { should route(:patch, '/lines/1/deactivate').to('lines#deactivate', {:id=>"1"}) } 
  it { should route(:get, '/lines').to('lines#index', {}) }
  it { should route(:get, '/lines/new').to('lines#new', {}) }
  it { should route(:patch, '/lines/1/remove_state/1').to('lines#remove_state', {:id=>"1", :line_state_id=>"1"}) } 
  it { should route(:get, '/lines/1').to('lines#show', {:id=>"1"}) }
  it { should route(:patch, '/lines/1').to('lines#update', {:id=>"1"}) } 
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
  it { should use_before_filter(:set_line) }
  it { should use_before_filter(:search_bar) }
  it { should use_before_filter(:set_line_and_line_state) }
  it { should use_before_filter(:do_authorization) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end