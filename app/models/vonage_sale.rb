# == Schema Information
#
# Table name: vonage_sales
#
#  id                  :integer          not null, primary key
#  sale_date           :date             not null
#  person_id           :integer          not null
#  confirmation_number :string           not null
#  location_id         :integer          not null
#  customer_first_name :string           not null
#  customer_last_name  :string           not null
#  mac                 :string           not null
#  vonage_product_id   :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  connect_order_uuid  :string
#  resold              :boolean          default(FALSE), not null
#  vested              :boolean
#

class VonageSale < ActiveRecord::Base
  include SaleAreaAndLocationAreaExtension

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
  has_one :vcp07012015_hps_sale

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
    changes_before_date = changes.
        where("account_end_date <= ? OR (account_end_date IS NULL AND status > 0 AND date_trunc('day', created_at) <= ?)",
              date,
              date)
    return true if changes_before_date.empty?
    false
  end

  def location_area
    self.location_area_for_sale 'Vonage'
  end
end
