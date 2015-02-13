class VonageSale < ActiveRecord::Base
  validates :sale_date, presence: true
  validates :person, presence: true
  validates :confirmation_number, length: { is: 10 }
  validates :location, presence: true
  validates :customer_first_name, presence: true
  validates :customer_last_name, presence: true
  validates :mac, length: { is: 12 }
  validates :vonage_product, presence: true

  belongs_to :person
  belongs_to :location
  belongs_to :vonage_product

  has_many :vonage_sale_payouts
  has_one :vonage_refund

  scope :for_paycheck, ->(paycheck) {
    if paycheck
      where('sale_date >= ? AND sale_date <= ?',
            paycheck.commission_start, paycheck.commission_end)
    else
      none
    end
  }
end
