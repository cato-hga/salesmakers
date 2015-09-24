require 'rails_helper'

RSpec.describe ReportQueriesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/report_queries').to('report_queries#index', {}) }
  it { should route(:get, '/report_queries/1').to('report_queries#show', {:id=>"1"}) }
  it { should route(:get, '/report_queries/1/csv').to('report_queries#csv', {:id=>"1", :format=>:csv}) }
  it { should route(:get, '/report_queries/new').to('report_queries#new', {}) }
  it { should route(:post, '/report_queries').to('report_queries#create', {}) } 
  it { should route(:get, '/report_queries/1/edit').to('report_queries#edit', {:id=>"1"}) }
  it { should route(:patch, '/report_queries/1').to('report_queries#update', {:id=>"1"}) } 
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
  it { should use_before_filter(:set_query_and_date_range) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end