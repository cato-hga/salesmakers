# == Schema Information
#
# Table name: vonage_paycheck_negative_balances
#
#  id                 :integer          not null, primary key
#  person_id          :integer          not null
#  balance            :decimal(, )      not null
#  vonage_paycheck_id :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class VonagePaycheckNegativeBalance < ActiveRecord::Base
  validates :person, presence: true, uniqueness: { scope: :vonage_paycheck }
  validates :balance, presence: true
  validates :vonage_paycheck, presence: true

  belongs_to :person
  belongs_to :vonage_paycheck
end
