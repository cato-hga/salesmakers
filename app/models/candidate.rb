class Candidate < ActiveRecord::Base
  extend NonAlphaNumericRansacker

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile_phone, presence: true, uniqueness: true
  validates :email, presence: true
  validates :zip, presence: true
  validates :project_id, presence: true
  validate :strip_phone_number
  belongs_to :project

  stripping_ransacker(:mobile_phone_number, :mobile_phone)

  def strip_phone_number
    self.mobile_phone = mobile_phone.strip.gsub /[^0-9]/, '' if mobile_phone.present?
  end
end
