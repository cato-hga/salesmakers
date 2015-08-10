# == Schema Information
#
# Table name: vonage_refunds
#
#  id                              :integer          not null, primary key
#  vonage_sale_id                  :integer          not null
#  vonage_account_status_change_id :integer          not null
#  refund_date                     :date             not null
#  person_id                       :integer          not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

class VonageRefund < ActiveRecord::Base
  validates :vonage_sale, presence: true, uniqueness: { scope: :person }
  validates :vonage_account_status_change, presence: true
  validates :refund_date, presence: true
  validates :person_id, presence: true

  belongs_to :vonage_sale
  belongs_to :vonage_account_status_change
  belongs_to :person

  def payout
    payouts = VonageSalePayout.where(vonage_sale: self.vonage_sale,
                                     person: self.person)
    payouts.empty? ? nil : payouts.first
  end
end
