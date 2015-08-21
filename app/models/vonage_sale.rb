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
#

class VonageSale < ActiveRecord::Base
  include SaleAreaAndLocationAreaExtension

  validates :sale_date, presence: true
  validates :person, presence: true
  validates :confirmation_number, length: { is: 10 }
  validates :location, presence: true
  validates :customer_first_name, presence: true
  validates :customer_last_name, presence: true
  validates :mac, format: { with: /\A[0-9A-F]{12}\z/i }, confirmation: true
  validates :vonage_product, presence: true
  validates :gift_card_number, format: { with: /\A([0-9A-Z]{16}|[0-9A-Z]{12})\z/i }, confirmation: true, if: :home_kit_with_gift_card_number?
  validates :person_acknowledged, acceptance: { accept: true }
  validate  :sale_date_cannot_be_more_than_2_weeks_in_the_past
  validate  :gift_card_number_required_for_whole_home_kit

  belongs_to :person
  belongs_to :location
  belongs_to :vonage_product
  belongs_to :connect_order, foreign_key: 'connect_order_uuid'

  has_many :vonage_sale_payouts
  has_one :vonage_refund
  has_many :vonage_account_status_changes, primary_key: 'mac', foreign_key: 'mac'
  has_one :vcp07012015_hps_sale

  nilify_blanks

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

  private

  def sale_date_cannot_be_more_than_2_weeks_in_the_past
    errors.add(:sale_date, "cannot be dated for more than 2 weeks in the past") if sale_date and sale_date <= 2.weeks.ago
  end

  def home_kit?
    kit = VonageProduct.find_by name: 'Vonage Whole Home Kit'
    return true if self.vonage_product == kit
    false
  end

  def home_kit_with_gift_card_number?
    return true if home_kit? and !self.gift_card_number.blank?
    false
  end

  def whole_home_kit_without_gift_card_number
    return true if home_kit? and gift_card_number.blank?
    false
  end

  def gift_card_number_required_for_whole_home_kit
    if whole_home_kit_without_gift_card_number
      errors.add(:gift_card_number, "must be entered if you have selected the Vonage whole home kit")
    end
  end

end
