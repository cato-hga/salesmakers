require 'rails_helper'

RSpec.describe ChannelsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/clients/1/projects/1/channels').to('channels#index', {:client_id=>"1", :project_id=>"1"}) }
  it { should route(:post, '/clients/1/projects/1/channels').to('channels#create', {:client_id=>"1", :project_id=>"1"}) } 
  it { should route(:get, '/clients/1/projects/1/channels/new').to('channels#new', {:client_id=>"1", :project_id=>"1"}) }
  it { should route(:get, '/clients/1/projects/1/channels/1/edit').to('channels#edit', {:client_id=>"1", :project_id=>"1", :id=>"1"}) }
  it { should route(:get, '/clients/1/projects/1/channels/1').to('channels#show', {:client_id=>"1", :project_id=>"1", :id=>"1"}) }
  it { should route(:patch, '/clients/1/projects/1/channels/1').to('channels#update', {:client_id=>"1", :project_id=>"1", :id=>"1"}) } 
  it { should route(:delete, '/clients/1/projects/1/channels/1').to('channels#destroy', {:client_id=>"1", :project_id=>"1", :id=>"1"}) } 
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
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end