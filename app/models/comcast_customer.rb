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
  validates :person_id, presence: true, uniqueness: true
  belongs_to :person
  validates_with CustomerPhoneValidator
end