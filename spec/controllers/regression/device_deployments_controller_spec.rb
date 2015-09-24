require 'rails_helper'

RSpec.describe DeviceDeploymentsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/devices/1/device_deployments/select_user').to('device_deployments#select_user', {:device_id=>"1"}) }
  it { should route(:get, '/devices/1/device_deployments/new/1').to('device_deployments#new', {:device_id=>"1", :person_id=>"1"}) }
  it { should route(:post, '/devices/1/device_deployments/new/1').to('device_deployments#create', {:device_id=>"1", :person_id=>"1"}) } 
  it { should route(:get, '/devices/1/device_deployments/1/edit').to('device_deployments#edit', {:device_id=>"1", :id=>"1"}) }
  it { should route(:patch, '/devices/1/device_deployments/1').to('device_deployments#update', {:device_id=>"1", :id=>"1"}) } 
  it { should route(:get, '/devices/1/device_deployments/recoup_notes').to('device_deployments#recoup_notes', {:device_id=>"1"}) }
  it { should route(:post, '/devices/1/device_deployments/recoup').to('device_deployments#recoup', {:device_id=>"1"}) } 
  it { should route(:delete, '/devices/1/device_deployments/1').to('device_deployments#destroy', {:device_id=>"1", :id=>"1"}) } 
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
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end