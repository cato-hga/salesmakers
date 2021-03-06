require 'rails_helper'

RSpec.describe DeviceModelsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/device_models').to('device_models#index', {}) }
  it { should route(:get, '/device_models/new').to('device_models#new', {}) }
  it { should route(:post, '/device_models').to('device_models#create', {}) } 
  it { should route(:get, '/device_models/1/edit').to('device_models#edit', {:id=>"1"}) }
  it { should route(:patch, '/device_models/1').to('device_models#update', {:id=>"1"}) } 
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