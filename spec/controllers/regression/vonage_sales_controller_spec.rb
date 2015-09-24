require 'rails_helper'

RSpec.describe VonageSalesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/vonage_sales').to('vonage_sales#index', {}) }
  it { should route(:get, '/vonage_sales/1').to('vonage_sales#show', {:id=>"1"}) }
  it { should route(:get, '/vonage_sales/new').to('vonage_sales#new', {}) }
  it { should route(:post, '/vonage_sales').to('vonage_sales#create', {}) } 
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
  it { should use_before_filter(:set_salesmaker) }
  it { should use_before_filter(:set_vonage_locations) }
  it { should use_before_filter(:set_vonage_product) }
  it { should use_before_filter(:chronic_time_zones) }
  it { should use_before_filter(:search_sales) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  it { should use_after_filter(:verify_policy_scoped) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end