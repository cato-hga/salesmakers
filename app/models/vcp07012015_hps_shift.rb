class VCP07012015HPSShift < ActiveRecord::Base
  validates :vonage_commission_period07012015, presence: true
  validates :shift, presence: true
  validates :person, presence: true
  validates :hours, presence: true

  belongs_to :vonage_commission_period07012015
  belongs_to :shift
  belongs_to :person
end