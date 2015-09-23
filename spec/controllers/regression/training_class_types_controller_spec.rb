require 'rails_helper'

RSpec.describe TrainingClassTypesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/training_class_types').to('training_class_types#create', {}) } 
  it { should route(:delete, '/training_class_types/1').to('training_class_types#destroy', {:id=>"1"}) } 
  it { should route(:get, '/training_class_types/1/edit').to('training_class_types#edit', {:id=>"1"}) }
  it { should route(:get, '/training_class_types').to('training_class_types#index', {}) }
  it { should route(:get, '/training_class_types/new').to('training_class_types#new', {}) }
  it { should route(:patch, '/training_class_types/1').to('training_class_types#update', {:id=>"1"}) } 
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
  it { should use_before_filter(:do_authorization) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end