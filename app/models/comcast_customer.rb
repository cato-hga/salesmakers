# == Schema Information
#
# Table name: comcast_customers
#
#  id                               :integer          not null, primary key
#  first_name                       :string           not null
#  last_name                        :string           not null
#  mobile_phone                     :string
#  other_phone                      :string
#  person_id                        :integer          not null
#  comments                         :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  location_id                      :integer          not null
#  comcast_lead_dismissal_reason_id :integer
#  dismissal_comment                :text
#

require 'validators/customer_phone_validator'
require 'sales_leads_customers/sales_leads_customers_model_extension'

class ComcastCustomer < ActiveRecord::Base
  include SalesLeadsCustomersModelExtension

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :person, presence: true
  validates :location, presence: true
  validates_with CustomerPhoneValidator
  validates :mobile_phone, uniqueness: true

  nilify_blanks

  belongs_to :person
  belongs_to :location
  belongs_to :comcast_lead_dismissal_reason
  has_one :comcast_lead
  has_one :comcast_sale
  has_many :comcast_customer_notes
  has_many :log_entries, as: :trackable, dependent: :destroy


  scope :manageable, ->(person = nil) {
    return Person.none unless person
    people = Array.new
    people = people.concat person.managed_team_members
    people << person
    return Person.none if people.count < 1

    ComcastCustomer.where("\"comcast_customers\".\"person_id\" IN (#{people.map(&:id).join(',')})")
  }

end
