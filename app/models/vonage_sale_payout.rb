class VonageSalePayout < ActiveRecord::Base
  validates :vonage_sale, presence: true, uniqueness: { scope: :person }
  validates :person, presence: true
  validates :payout, presence: true
  validates :vonage_paycheck, presence: true

  belongs_to :vonage_sale
  belongs_to :person
  belongs_to :vonage_paycheck
end
