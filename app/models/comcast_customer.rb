require 'validators/customer_phone_validator'
require 'sales_leads_customers/sales_leads_customers_model_extension'

class ComcastCustomer < ActiveRecord::Base
  include SalesLeadsCustomersModelExtension

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :person, presence: true
  validates :location, presence: true
  validates_with CustomerPhoneValidator

  nilify_blanks

  belongs_to :person
  belongs_to :location
  has_one :comcast_lead
  has_one :comcast_sale
  has_many :comcast_customer_notes

  scope :manageable, ->(person = nil) {
    return Person.none unless person
    people = Array.new
    people = people.concat person.managed_team_members
    people << person
    return Person.none if people.count < 1

    ComcastCustomer.where("\"comcast_customers\".\"person_id\" IN (#{people.map(&:id).join(',')})")
  }

end