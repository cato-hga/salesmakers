require 'validators/phone_number_validator'
class ComcastCustomer < ActiveRecord::Base

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :person_id, presence: true, uniqueness: true
  validates_with PhoneNumberValidator

  belongs_to :person
end
