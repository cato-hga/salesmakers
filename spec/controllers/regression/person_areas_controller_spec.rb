require 'rails_helper'

RSpec.describe PersonAreasController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/people/1/person_areas').to('person_areas#create', {:person_id=>"1"}) } 
  it { should route(:delete, '/people/1/person_areas/1').to('person_areas#destroy', {:person_id=>"1", :id=>"1"}) } 
  it { should route(:get, '/people/1/person_areas/1/edit').to('person_areas#edit', {:person_id=>"1", :id=>"1"}) }
  it { should route(:get, '/people/1/person_areas').to('person_areas#index', {:person_id=>"1"}) }
  it { should route(:get, '/people/1/person_areas/new').to('person_areas#new', {:person_id=>"1"}) }
  it { should route(:patch, '/people/1/person_areas/1').to('person_areas#update', {:person_id=>"1", :id=>"1"}) } 
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
  it { should use_before_filter(:set_projects) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end