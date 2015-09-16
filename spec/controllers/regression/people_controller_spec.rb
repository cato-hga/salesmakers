require 'rails_helper'

RSpec.describe PeopleController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/people').to('people#index', {}) }
  it { should route(:get, '/people/csv').to('people#csv', {:format=>:csv}) }
  it { should route(:get, '/people/org_chart').to('people#org_chart', {}) }
  it { should route(:get, '/people/1').to('people#show', {:id=>"1"}) }
  it { should route(:get, '/people/1/masquerade').to('people#masquerade', {:id=>"1"}) }
  it { should route(:get, '/people/new/1').to('people#new', {:candidate_id=>"1"}) }
  it { should route(:post, '/people').to('people#create', {}) } 
  it { should route(:get, '/people/1/new_sms_message').to('people#new_sms_message', {:id=>"1"}) }
  it { should route(:post, '/people/1/create_sms_message').to('people#create_sms_message', {:id=>"1"}) } 
  it { should route(:get, '/people/1/edit_position').to('people#edit_position', {:id=>"1"}) }
  it { should route(:put, '/people/1/update_position').to('people#update_position', {:id=>"1"}) } 
  it { should route(:patch, '/people/1').to('people#update', {:id=>"1"}) } 
  it { should route(:get, '/people/search').to('people#search', {}) }
  it { should route(:get, '/people/1/commission').to('people#commission', {:id=>"1"}) }
  it { should route(:put, '/people/1/update_changelog_entry_id/1').to('people#update_changelog_entry_id', {:id=>"1", :changelog_entry_id=>"1"}) } 
  it { should route(:post, '/people/1/send_asset_form').to('people#send_asset_form', {:id=>"1"}) } 
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
  it { should use_before_filter(:find_person) }
  it { should use_before_filter(:setup_onboarding_fields) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  it { should use_after_filter(:verify_policy_scoped) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end