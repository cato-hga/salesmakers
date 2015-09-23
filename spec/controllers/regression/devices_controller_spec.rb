require 'rails_helper'

RSpec.describe DevicesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:patch, '/devices/1/add_state').to('devices#add_state', {:id=>"1"}) } 
  it { should route(:post, '/devices').to('devices#create', {}) } 
  it { should route(:get, '/devices/csv').to('devices#csv', {:format=>:csv}) }
  it { should route(:get, '/devices/1/edit').to('devices#edit', {:id=>"1"}) }
  it { should route(:patch, '/devices/1/found').to('devices#found', {:id=>"1"}) } 
  it { should route(:get, '/devices').to('devices#index', {}) }
  it { should route(:get, '/devices/line_edit/1').to('devices#line_edit', {:line_id=>"1"}) }
  it { should route(:patch, '/devices/1/line_move_finalize/1').to('devices#line_move_finalize', {:id=>"1", :device_id=>"1"}) } 
  it { should route(:get, '/devices/1/line_move_results/1').to('devices#line_move_results', {:id=>"1", :device_id=>"1"}) }
  it { should route(:patch, '/devices/1/line_swap_finalize/1').to('devices#line_swap_finalize', {:id=>"1", :device_id=>"1"}) } 
  it { should route(:get, '/devices/1/line_swap_or_move').to('devices#line_swap_or_move', {:id=>"1"}) }
  it { should route(:get, '/devices/1/line_swap_results/1').to('devices#line_swap_results', {:id=>"1", :device_id=>"1"}) }
  it { should route(:patch, '/devices/1/line_update/1').to('devices#line_update', {:id=>"1", :line_id=>"1"}) } 
  it { should route(:patch, '/devices/1/lost_stolen').to('devices#lost_stolen', {:id=>"1"}) } 
  it { should route(:get, '/devices/new').to('devices#new', {}) }
  it { should route(:patch, '/devices/1/remove_state/1').to('devices#remove_state', {:id=>"1", :device_state_id=>"1"}) } 
  it { should route(:patch, '/devices/1/repaired').to('devices#repaired', {:id=>"1"}) } 
  it { should route(:patch, '/devices/1/repairing').to('devices#repairing', {:id=>"1"}) } 
  it { should route(:get, '/devices/1').to('devices#show', {:id=>"1"}) }
  it { should route(:patch, '/devices/1').to('devices#update', {:id=>"1"}) } 
  it { should route(:get, '/devices/1/write_off').to('devices#write_off', {:id=>"1"}) }
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
  it { should use_before_filter(:search_bar) }
  it { should use_before_filter(:set_models_and_providers) }
  it { should use_before_filter(:set_device_and_device_state) }
  it { should use_before_filter(:do_authorization) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end