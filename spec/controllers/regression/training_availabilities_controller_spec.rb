require 'rails_helper'

RSpec.describe TrainingAvailabilitiesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/candidates/1/training_availabilities/new').to('training_availabilities#new', {:candidate_id=>"1"}) }
  it { should route(:post, '/candidates/1/training_availabilities').to('training_availabilities#create', {:candidate_id=>"1"}) } 
  it { should route(:get, '/candidates/1/training_availabilities/1/edit').to('training_availabilities#edit', {:candidate_id=>"1", :id=>"1"}) }
  it { should route(:patch, '/candidates/1/training_availabilities/1').to('training_availabilities#update', {:candidate_id=>"1", :id=>"1"}) } 
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
  it { should use_before_filter(:do_authorization) }
  it { should use_before_filter(:search_bar) }
  it { should use_before_filter(:setup_params) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end