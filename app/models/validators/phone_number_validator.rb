class PhoneNumberValidator < ActiveModel::Validator
  def validate(record)
    unless record.mobile_phone.present? or record.office_phone.present? or record.home_phone.present?
      record.errors[:mobile_phone] << 'At least one phone number is required' #TODO: Format this error
      return
    end
    record.mobile_phone = record.mobile_phone.strip.gsub /[^0-9]/, '' if record.mobile_phone.present?
    record.home_phone = record.home_phone.strip.gsub /[^0-9]/, '' if record.home_phone.present?
    record.office_phone = record.office_phone.strip.gsub /[^0-9]/, '' if record.office_phone.present?
    if record.mobile_phone.present? and record.mobile_phone.length != 10
      record.errors[:mobile_phone] << 'Mobile phone number must be 10 digits long and include your area code'
    end
    if record.home_phone.present? and record.home_phone.length != 10
      record.errors[:home_phone] << 'Home phone number must be 10 digits long and include your area code'
    end
    if record.office_phone.present? and record.office_phone.length != 10
      record.errors[:office_phone] << 'Office phone number must be 10 digits long and include your area code'
    end
  end
end