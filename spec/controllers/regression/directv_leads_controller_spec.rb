require 'rails_helper'

RSpec.describe DirecTVLeadsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/directv_customers/1/directv_leads').to('directv_leads#create', {:directv_customer_id=>"1"}) } 
  it { should route(:get, '/directv_leads/csv').to('directv_leads#csv', {:format=>:csv}) }
  it { should route(:delete, '/directv_customers/1/directv_leads/1').to('directv_leads#destroy', {:directv_customer_id=>"1", :id=>"1"}) } 
  it { should route(:get, '/directv_customers/1/directv_leads/1/dismiss').to('directv_leads#dismiss', {:directv_customer_id=>"1", :id=>"1"}) }
  it { should route(:get, '/directv_customers/1/directv_leads/1/edit').to('directv_leads#edit', {:directv_customer_id=>"1", :id=>"1"}) }
  it { should route(:get, '/directv_leads').to('directv_leads#index', {}) }
  it { should route(:get, '/directv_customers/1/directv_leads/new').to('directv_leads#new', {:directv_customer_id=>"1"}) }
  it { should route(:get, '/directv_customers/1/directv_leads/1/reassign').to('directv_leads#reassign', {:directv_customer_id=>"1", :id=>"1"}) }
  it { should route(:patch, '/directv_customers/1/directv_leads/1/reassign_to/1').to('directv_leads#reassign_to', {:directv_customer_id=>"1", :id=>"1", :person_id=>"1"}) } 
  it { should route(:patch, '/directv_customers/1/directv_leads/1').to('directv_leads#update', {:directv_customer_id=>"1", :id=>"1"}) } 
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
  it { should use_before_filter(:set_directv_customer) }
  it { should use_before_filter(:do_authorization) }
  it { should use_before_filter(:set_directv_locations) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  it { should use_after_filter(:verify_policy_scoped) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end