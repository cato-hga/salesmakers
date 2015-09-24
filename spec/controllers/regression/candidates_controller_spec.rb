require 'rails_helper'

RSpec.describe CandidatesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/candidates').to('candidates#index', {}) }
  it { should route(:get, '/candidates/csv').to('candidates#csv', {:format=>:csv}) }
  it { should route(:get, '/candidates/support_search').to('candidates#support_search', {}) }
  it { should route(:get, '/candidates/1').to('candidates#show', {:id=>"1"}) }
  it { should route(:get, '/candidates/new').to('candidates#new', {}) }
  it { should route(:post, '/candidates').to('candidates#create', {}) } 
  it { should route(:get, '/candidates/1/edit').to('candidates#edit', {:id=>"1"}) }
  it { should route(:patch, '/candidates/1').to('candidates#update', {:id=>"1"}) } 
  it { should route(:put, '/candidates/1/set_reconciliation_status').to('candidates#set_reconciliation_status', {:id=>"1"}) } 
  it { should route(:post, '/candidates/1/cant_make_training_location').to('candidates#cant_make_training_location', {:id=>"1"}) } 
  it { should route(:put, '/candidates/1/set_sprint_radio_shack_training_session').to('candidates#set_sprint_radio_shack_training_session', {:id=>"1"}) } 
  it { should route(:put, '/candidates/1/set_training_session_status').to('candidates#set_training_session_status', {:id=>"1"}) } 
  it { should route(:get, '/candidates/1/dismiss').to('candidates#dismiss', {:id=>"1"}) }
  it { should route(:patch, '/candidates/1/reactivate').to('candidates#reactivate', {:id=>"1"}) } 
  it { should route(:delete, '/candidates/1').to('candidates#destroy', {:id=>"1"}) } 
  it { should route(:get, '/candidates/1/new_sms_message').to('candidates#new_sms_message', {:id=>"1"}) }
  it { should route(:post, '/candidates/1/create_sms_message').to('candidates#create_sms_message', {:id=>"1"}) } 
  it { should route(:get, '/candidates/1/send_paperwork').to('candidates#send_paperwork', {:id=>"1"}) }
  it { should route(:get, '/candidates/1/resend_paperwork').to('candidates#resend_paperwork', {:id=>"1"}) }
  it { should route(:get, '/candidates/1/select_location/1').to('candidates#select_location', {:id=>"1", :back_to_confirm=>"1"}) }
  it { should route(:get, '/candidates/1/set_location_area/1/1').to('candidates#set_location_area', {:id=>"1", :location_area_id=>"1", :back_to_confirm=>"1"}) }
  it { should route(:get, '/candidates/1/get_override_location').to('candidates#get_override_location', {:id=>"1"}) }
  it { should route(:patch, '/candidates/1/post_override_location/1').to('candidates#post_override_location', {:id=>"1", :location_area_id=>"1"}) } 
  it { should route(:put, '/candidates/1/record_assessment_score').to('candidates#record_assessment_score', {:id=>"1"}) } 
  it { should route(:get, '/candidates/1/resend_assessment').to('candidates#resend_assessment', {:id=>"1"}) }
  it { should route(:get, '/candidates/dashboard').to('candidates#dashboard', {}) }
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
  it { should use_before_filter(:search_bar) }
  it { should use_before_filter(:get_candidate) }
  it { should use_before_filter(:get_suffixes_and_sources) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end