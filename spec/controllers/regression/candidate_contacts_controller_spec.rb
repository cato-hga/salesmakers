require 'rails_helper'

RSpec.describe CandidateContactsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/candidates/1/candidate_contacts/new_call').to('candidate_contacts#new_call', {:candidate_id=>"1"}) }
  it { should route(:post, '/candidates/1/candidate_contacts').to('candidate_contacts#create', {:candidate_id=>"1"}) } 
  it { should route(:put, '/candidates/1/candidate_contacts/save_call_results').to('candidate_contacts#save_call_results', {:candidate_id=>"1"}) } 
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
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end