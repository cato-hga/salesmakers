require 'rails_helper'

RSpec.describe WalmartGiftCardsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/walmart_gift_cards/new').to('walmart_gift_cards#new', {}) }
  it { should route(:get, '/walmart_gift_cards/new_override/1').to('walmart_gift_cards#new_override', {:person_id=>"1"}) }
  it { should route(:post, '/walmart_gift_cards/create_override').to('walmart_gift_cards#create_override', {}) } 
  it { should route(:post, '/walmart_gift_cards').to('walmart_gift_cards#create', {}) } 
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