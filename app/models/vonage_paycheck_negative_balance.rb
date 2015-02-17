class VonagePaycheckNegativeBalance < ActiveRecord::Base
  validates :person, presence: true, uniqueness: { scope: :vonage_paycheck }
  validates :balance, presence: true
  validates :vonage_paycheck, presence: true

  belongs_to :person
  belongs_to :vonage_paycheck
end
