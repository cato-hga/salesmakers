require 'rails_helper'

RSpec.describe ComcastLeadsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/comcast_customers/1/comcast_leads').to('comcast_leads#create', {:comcast_customer_id=>"1"}) } 
  it { should route(:get, '/comcast_leads/csv').to('comcast_leads#csv', {:format=>:csv}) }
  it { should route(:delete, '/comcast_customers/1/comcast_leads/1').to('comcast_leads#destroy', {:comcast_customer_id=>"1", :id=>"1"}) } 
  it { should route(:get, '/comcast_customers/1/comcast_leads/1/dismiss').to('comcast_leads#dismiss', {:comcast_customer_id=>"1", :id=>"1"}) }
  it { should route(:get, '/comcast_customers/1/comcast_leads/1/edit').to('comcast_leads#edit', {:comcast_customer_id=>"1", :id=>"1"}) }
  it { should route(:get, '/comcast_leads').to('comcast_leads#index', {}) }
  it { should route(:get, '/comcast_customers/1/comcast_leads/new').to('comcast_leads#new', {:comcast_customer_id=>"1"}) }
  it { should route(:get, '/comcast_customers/1/comcast_leads/1/reassign').to('comcast_leads#reassign', {:comcast_customer_id=>"1", :id=>"1"}) }
  it { should route(:patch, '/comcast_customers/1/comcast_leads/1/reassign_to/1').to('comcast_leads#reassign_to', {:comcast_customer_id=>"1", :id=>"1", :person_id=>"1"}) } 
  it { should route(:patch, '/comcast_customers/1/comcast_leads/1').to('comcast_leads#update', {:comcast_customer_id=>"1", :id=>"1"}) } 
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
  it { should use_before_filter(:set_comcast_customer) }
  it { should use_before_filter(:do_authorization) }
  it { should use_before_filter(:set_comcast_locations) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  it { should use_after_filter(:verify_policy_scoped) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end