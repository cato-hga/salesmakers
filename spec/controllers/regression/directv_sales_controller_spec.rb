require 'rails_helper'

RSpec.describe DirecTVSalesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/directv_sales').to('directv_sales#index', {}) }
  it { should route(:get, '/directv_customers/1/directv_sales/new').to('directv_sales#new', {:directv_customer_id=>"1"}) }
  it { should route(:post, '/directv_customers/1/directv_sales').to('directv_sales#create', {:directv_customer_id=>"1"}) } 
  it { should route(:get, '/directv_sales/csv').to('directv_sales#csv', {:format=>:csv}) }
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
  it { should use_before_filter(:setup_directv_customer) }
  it { should use_before_filter(:setup_time_slots) }
  it { should use_before_filter(:setup_former_providers) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_policy_scoped) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end