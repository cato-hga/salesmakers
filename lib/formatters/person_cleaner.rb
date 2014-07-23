require 'delegate'

class Formatters::PersonCleaner < SimpleDelegator

  def clean_phone_numbers
    if self.mobile_phone
      self.mobile_phone = self.mobile_phone.strip
      self.mobile_phone = '8005551212' unless /\A[2-9][0-9]{2}[1-9][0-9]{6}\z/.match(self.mobile_phone)
    end
    if self.home_phone
      self.home_phone = self.home_phone.strip
      self.home_phone = '8005551212' unless /\A[2-9][0-9]{2}[1-9][0-9]{6}\z/.match(self.home_phone)
    end
    if self.office_phone
      self.office_phone = self.office_phone.strip
      self.office_phone = '8005551212' unless /\A[2-9][0-9]{2}[1-9][0-9]{6}\z/.match(self.office_phone)
    end
  end

  def clean_email
    return unless self.email
    return if self.email.match /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/
    self.email = self.email.gsub /[^0-9A-Za-z]/, ''
    self.email = self.email.strip
    self.email = self.email + '@retailingwireless.com' unless self.email.match /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/
  end

  def clean_personal_email
    return unless self.personal_email
    self.personal_email = nil unless self.personal_email.match /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/
  end

end