require 'rails_helper'

RSpec.describe InterviewSchedulesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/interview_schedules/1').to('interview_schedules#index', {:schedule_date=>"1"}) }
  it { should route(:get, '/candidates/1/interview_schedules/new').to('interview_schedules#new', {:candidate_id=>"1"}) }
  it { should route(:post, '/candidates/1/interview_schedules').to('interview_schedules#create', {:candidate_id=>"1"}) } 
  it { should route(:post, '/candidates/1/interview_schedules/schedule/1/1').to('interview_schedules#schedule', {:candidate_id=>"1", :interview_date=>"1", :interview_time=>"1"}) } 
  it { should route(:get, '/candidates/1/interview_schedules/interview_now').to('interview_schedules#interview_now', {:candidate_id=>"1"}) }
  it { should route(:post, '/candidates/1/interview_schedules/time_slots').to('interview_schedules#time_slots', {:candidate_id=>"1"}) } 
  it { should route(:delete, '/candidates/1/interview_schedules/1').to('interview_schedules#destroy', {:candidate_id=>"1", :id=>"1"}) } 
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
  it { should use_before_filter(:do_authorization) }
  it { should use_before_filter(:chronic_time_zones) }
  it { should use_before_filter(:set_candidate) }
  it { should use_before_filter(:get_and_handle_inputted_date) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end