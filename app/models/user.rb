# == Schema Information
#
# Table name: people
#
#  id                                   :integer          not null, primary key
#  first_name                           :string           not null
#  last_name                            :string           not null
#  display_name                         :string           not null
#  email                                :string           not null
#  personal_email                       :string
#  position_id                          :integer
#  created_at                           :datetime
#  updated_at                           :datetime
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
#

class User < Person
  #Making every Person a User for Sentient User gem compatibility
  #include SentientUser
end
