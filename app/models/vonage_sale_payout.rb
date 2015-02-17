class VonageSalePayout < ActiveRecord::Base
  validates :vonage_sale, presence: true, uniqueness: { scope: :person }
  validates :person, presence: true
  validates :payout, presence: true
  validates :vonage_paycheck, presence: true

  belongs_to :vonage_sale
  belongs_to :person
  belongs_to :vonage_paycheck

  default_scope {
    joins(:vonage_sale).
        order("vonage_sales.sale_date").
        includes(:vonage_sale)
  }
end
