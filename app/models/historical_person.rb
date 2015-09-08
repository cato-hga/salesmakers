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

require 'validators/phone_number_validator'

class HistoricalPerson < ActiveRecord::Base
  validates :date, presence: true
  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }
  validates :display_name, length: { minimum: 5 }
  validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }
  validates :personal_email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }, allow_blank: true
  validates_with PhoneNumberValidator

  belongs_to :supervisor, class_name: 'HistoricalPerson'
  belongs_to :position
  belongs_to :connect_user

  has_many :historical_person_areas
  has_many :historical_person_client_areas

  has_many :historical_areas, through: :historical_person_areas

  enum vonage_tablet_approval_status: [
           :no_decision,
           :denied,
           :approved
       ]
  enum sprint_prepaid_asset_approval_status: [
           :prepaid_no_decision,
           :prepaid_denied,
           :prepaid_approved
       ]
end
