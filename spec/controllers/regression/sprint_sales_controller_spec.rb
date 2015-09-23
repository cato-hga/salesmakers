require 'rails_helper'

RSpec.describe SprintSalesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/sprint_sales/new/1').to('sprint_sales#create', {:project_id=>"1"}) } 
  it { should route(:get, '/sprint_sales/csv').to('sprint_sales#csv', {:format=>:csv}) }
  it { should route(:get, '/sprint_sales').to('sprint_sales#index', {}) }
  it { should route(:get, '/sprint_sales/new/1').to('sprint_sales#new', {:project_id=>"1"}) }
  it { should route(:get, '/sprint_sales/scoreboard').to('sprint_sales#scoreboard', {}) }
  it { should route(:get, '/sprint_sales/1').to('sprint_sales#show', {:id=>"1"}) }
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
  it { should use_before_filter(:chronic_time_zones) }
  it { should use_before_filter(:set_salesmakers) }
  it { should use_before_filter(:get_project) }
  it { should use_before_filter(:do_authorization) }
  it { should use_before_filter(:search_sales) }
  it { should use_before_filter(:set_carrier_based_on_project) }
  it { should use_before_filter(:set_sprint_locations) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end