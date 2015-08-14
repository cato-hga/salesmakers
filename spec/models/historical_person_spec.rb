# == Schema Information
#
# Table name: historical_people
#
#  id                                   :integer          not null, primary key
#  first_name                           :string           not null
#  last_name                            :string           not null
#  display_name                         :string           not null
#  email                                :string           not null
#  personal_email                       :string
#  position_id                          :integer
#  active                               :boolean          default(TRUE), not null
#  connect_user_id                      :string
#  supervisor_id                        :integer
#  office_phone                         :string
#  mobile_phone                         :string
#  home_phone                           :string
#  eid                                  :integer
#  groupme_access_token                 :string
#  groupme_token_updated                :datetime
#  group_me_user_id                     :string
#  last_seen                            :datetime
#  changelog_entry_id                   :integer
#  vonage_tablet_approval_status        :integer          default(0), not null
#  passed_asset_hours_requirement       :boolean          default(FALSE), not null
#  sprint_prepaid_asset_approval_status :integer          default(0), not null
#  update_position_from_connect         :boolean          default(TRUE), not null
#  mobile_phone_valid                   :boolean          default(TRUE), not null
#  home_phone_valid                     :boolean          default(TRUE), not null
#  office_phone_valid                   :boolean          default(TRUE), not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  date                                 :date             not null
#

require 'rails_helper'

describe HistoricalPerson do
  subject { create :historical_person }

  it do
    should allow_value('a@b.com').for(:email)
    should allow_value('a@b.com').for(:personal_email)
    should_not allow_value('a@b', 'ab.com').for(:email)
    should_not allow_value('a@b', 'ab.com').for(:personal_email)
    should allow_value('2134567890').for(:mobile_phone)
    should allow_value('2134567890').for(:office_phone)
    should allow_value('2134567890').for(:home_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:mobile_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:office_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:home_phone)
  end

  it 'responds to historical_person_client_areas' do
    expect(subject).to respond_to(:historical_person_client_areas)
  end

  it 'responds to mobile_phone_valid?' do
    expect(subject).to respond_to :mobile_phone_valid?
  end

  it 'responds to home_phone_valid?' do
    expect(subject).to respond_to :home_phone_valid?
  end

  it 'responds to office_phone_valid?' do
    expect(subject).to respond_to :office_phone_valid?
  end
end
