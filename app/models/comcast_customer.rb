class CustomerPhoneValidator < ActiveModel::Validator
  def validate(record)
    unless record.mobile_phone.present? or record.other_phone.present?
      record.errors[:mobile_phone] << 'is required if there is no Mobile or other phone'
      return
    end
    record.mobile_phone = record.mobile_phone.strip.gsub /[^0-9]/, '' if record.mobile_phone.present?
    record.other_phone = record.other_phone.strip.gsub /[^0-9]/, '' if record.other_phone.present?
    if record.mobile_phone.present? and record.mobile_phone.length != 10
      record.errors[:mobile_phone] << 'number must be 10 digits long and include your area code'
    end
    if record.other_phone.present? and record.other_phone.length != 10
      record.errors[:other_phone] << 'number must be 10 digits long and include your area code'
    end
  end
end

class ComcastCustomer < ActiveRecord::Base
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

  def name
    NameCase([self.first_name, self.last_name].join(' '))
  end
end