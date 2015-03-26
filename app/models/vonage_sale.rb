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
  belongs_to :connect_order, foreign_key: 'connect_order_uuid'

  has_many :vonage_sale_payouts
  has_one :vonage_refund
  has_many :vonage_account_status_changes, primary_key: 'mac', foreign_key: 'mac'

  scope :for_paycheck, ->(paycheck) {
    if paycheck
      where('sale_date >= ? AND sale_date <= ?',
            paycheck.commission_start, paycheck.commission_end)
    else
      none
    end
  }

  scope :for_date_range, ->(start_date, end_date) {
    where('sale_date >= ? AND sale_date <= ?',
          start_date, end_date)
  }

  def still_active_on?(date)
    changes = self.vonage_account_status_changes
    return false if changes.empty?
    changes_before_date = changes.where("account_end_date <= ?", date)
    return true if changes_before_date.empty?
    false
  end
end
