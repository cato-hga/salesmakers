require 'validators/customer_phone_validator'
class DirecTVCustomer < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :person, presence: true
  validates :location, presence: true
  validates_with CustomerPhoneValidator

  nilify_blanks

  belongs_to :person
  belongs_to :location
  has_one :directv_lead
  has_one :directv_sale

  scope :manageable, ->(person = nil) {
    return Person.none unless person
    people = Array.new
    people = people.concat person.managed_team_members
    people << person
    return Person.none if people.count < 1

    DirecTVCustomer.where("\"directv_customers\".\"person_id\" IN (#{people.map(&:id).join(',')})")
  }

  def name
    NameCase([self.first_name, self.last_name].join(' '))
  end
end
