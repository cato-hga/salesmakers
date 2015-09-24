require 'rails_helper'

RSpec.describe SprintRadioShackTrainingSessionsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/sprint_radio_shack_training_sessions').to('sprint_radio_shack_training_sessions#index', {}) }
  it { should route(:get, '/sprint_radio_shack_training_sessions/new').to('sprint_radio_shack_training_sessions#new', {}) }
  it { should route(:post, '/sprint_radio_shack_training_sessions').to('sprint_radio_shack_training_sessions#create', {}) } 
  it { should route(:get, '/sprint_radio_shack_training_sessions/1/edit').to('sprint_radio_shack_training_sessions#edit', {:id=>"1"}) }
  it { should route(:patch, '/sprint_radio_shack_training_sessions/1').to('sprint_radio_shack_training_sessions#update', {:id=>"1"}) } 
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
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end