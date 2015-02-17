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
