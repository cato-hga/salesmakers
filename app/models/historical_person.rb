require 'validators/phone_number_validator'

class HistoricalPerson < ActiveRecord::Base
  validates :date, presence: true
  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }
  validates :display_name, length: { minimum: 5 }
  validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }, uniqueness: true
  validates :personal_email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }, allow_blank: true
  validates :connect_user_id, uniqueness: true, allow_nil: true
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
