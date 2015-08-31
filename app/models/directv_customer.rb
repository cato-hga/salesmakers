# == Schema Information
#
# Table name: directv_customers
#
#  id                               :integer          not null, primary key
#  first_name                       :string           not null
#  last_name                        :string           not null
#  mobile_phone                     :string
#  other_phone                      :string
#  person_id                        :integer
#  comments                         :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  location_id                      :integer
#  directv_lead_dismissal_reason_id :integer
#  dismissal_comment                :text
#

require 'validators/customer_phone_validator'
require 'sales_leads_customers/sales_leads_customers_model_extension'

class DirecTVCustomer < ActiveRecord::Base
  include SalesLeadsCustomersModelExtension

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :person, presence: true
  validates :location, presence: true
  validates :mobile_phone, uniqueness: true
  validates_with CustomerPhoneValidator

  strip_attributes

  belongs_to :person
  belongs_to :location
  belongs_to :directv_lead_dismissal_reason
  has_one :directv_lead
  has_one :directv_sale
  has_many :directv_customer_notes
  has_many :log_entries, as: :trackable, dependent: :destroy

  scope :manageable, ->(person = nil) {
    return Person.none unless person
    people = Array.new
    people = people.concat person.managed_team_members
    people << person
    return Person.none if people.count < 1

    DirecTVCustomer.where("\"directv_customers\".\"person_id\" IN (#{people.map(&:id).join(',')})")
  }

end
