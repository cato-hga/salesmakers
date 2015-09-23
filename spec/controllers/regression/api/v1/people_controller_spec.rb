require 'rails_helper'

RSpec.describe API::V1::PeopleController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/people/onboard/1').to('api/v1/people#onboard', {:connect_user_id=>"1", :format=>:json}) }
  it { should route(:get, '/api/v1/people/separate/1').to('api/v1/people#separate', {:connect_user_id=>"1", :format=>:json}) }
  it { should route(:get, '/api/v1/people/update/1').to('api/v1/people#update', {:connect_user_id=>"1", :format=>:json}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_ahoy_cookies) }
  it { should use_before_filter(:track_ahoy_visit) }
  it { should use_before_filter(:set_paper_trail_enabled_for_controller) }
  it { should use_before_filter(:set_paper_trail_controller_info) }
  it { should use_before_filter(:additional_exception_data) }
  it { should use_before_filter(:set_staging) }
  it { should use_before_filter(:record_action_event) }
  it { should use_before_filter(:set_unseen_changelog_entries) }
  it { should use_before_filter(:log_additional_data) }
  it { should use_before_filter(:authorize_profiler) }
  # === Callbacks (After) ===
  it { should use_after_filter(:warn_about_not_setting_whodunnit) }
  it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end