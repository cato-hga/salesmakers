require 'rails_helper'

RSpec.describe ComcastSalesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/comcast_sales').to('comcast_sales#index', {}) }
  it { should route(:get, '/comcast_customers/1/comcast_sales/new').to('comcast_sales#new', {:comcast_customer_id=>"1"}) }
  it { should route(:post, '/comcast_customers/1/comcast_sales').to('comcast_sales#create', {:comcast_customer_id=>"1"}) } 
  it { should route(:get, '/comcast_sales/csv').to('comcast_sales#csv', {:format=>:csv}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
  it { should use_before_filter(:set_paper_trail_enabled_for_controller) }
  it { should use_before_filter(:set_paper_trail_whodunnit) }
  it { should use_before_filter(:set_paper_trail_controller_info) }
  it { should use_before_filter(:additional_exception_data) }
  it { should use_before_filter(:set_staging) }
  it { should use_before_filter(CASClient::Frameworks::Rails::Filter) }
  it { should use_before_filter(:set_current_user) }
  it { should use_before_filter(:check_active) }
  it { should use_before_filter(:setup_accessibles) }
  it { should use_before_filter(:set_unseen_changelog_entries) }
  it { should use_before_filter(:log_additional_data) }
  it { should use_before_filter(:authorize_profiler) }
  it { should use_before_filter(:setup_comcast_customer) }
  it { should use_before_filter(:setup_time_slots) }
  it { should use_before_filter(:setup_former_providers) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_policy_scoped) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end