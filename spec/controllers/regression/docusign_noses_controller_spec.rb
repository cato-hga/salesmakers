require 'rails_helper'

RSpec.describe DocusignNosesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/people/1/docusign_noses/new').to('docusign_noses#new', {:person_id=>"1"}) }
  it { should route(:post, '/people/1/docusign_noses').to('docusign_noses#create', {:person_id=>"1"}) } 
  it { should route(:get, '/people/1/docusign_noses/new_third_party').to('docusign_noses#new_third_party', {:person_id=>"1"}) }
  it { should route(:post, '/people/1/docusign_noses/create_third_party').to('docusign_noses#create_third_party', {:person_id=>"1"}) } 
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
  it { should use_before_filter(:get_person) }
  it { should use_before_filter(:do_authorization) }
  # === Callbacks (After) ===
  it { should use_after_filter(:verify_same_origin_request) }
  it { should use_after_filter(:verify_authorized) }
  # === Callbacks (Around) ===
  it { should use_around_filter(:set_time_zone) }
end