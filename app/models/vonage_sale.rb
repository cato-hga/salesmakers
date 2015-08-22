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
#  person_acknowledged :boolean          default(FALSE)
#  gift_card_number    :string
#  vested              :boolean
#  creator_id          :integer
#

class VonageSale < ActiveRecord::Base
  include SaleAreaAndLocationAreaExtension

  validates :sale_date, presence: true
  validate  :sale_date_cannot_be_more_than_2_weeks_in_the_past
  validates :person, presence: true
  validates :confirmation_number, length: { is: 10 }
  validates :location, presence: true
  validates :customer_first_name, format: { with: /\A[a-zA-Z_\-]+\z/i }, unless: :blank_first_name
  validate  :customer_first_name_cannot_be_blank
  validates :customer_last_name, format: { with: /\A[a-zA-Z_\-]+\z/i }, unless: :blank_last_name
  validate  :customer_last_name_cannot_be_blank
  validates :mac, format: { with: /\A[0-9A-F]{12}\z/i }, confirmation: true
  validates :vonage_product, presence: true
  validates :gift_card_number, format: { with: /\A([0-9A-Z]{16}|[0-9A-Z]{12})\z/i }, confirmation: true, if: :home_kit_with_gift_card_number?
  validate  :gift_card_number_required_for_whole_home_kit
  validates :person_acknowledged, acceptance: { accept: true, message: 'gift card rules and regulations must be checked.' }
  validate :mac_prefix_valid

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

  def mac= mac
    if mac
      self[:mac] = mac.upcase
    else
      self[:mac] = nil
    end
  end

  def location_area
    self.location_area_for_sale 'Vonage'
  end

  private

  def blank_first_name
    self.customer_first_name.blank?
  end

  def blank_last_name
    self.customer_last_name.blank?
  end

  def mac_prefix_valid
    return if self.location and self.location.channel.name == 'Vonage Event Teams'
    if self.mac && !VonageMacPrefix.find_by(prefix: self.mac[0..5])
      errors.add :mac, 'has first 6 digits that are not in the known list of valid Vonage MAC prefixes. Please contact support.'
    end
  end

  def customer_first_name_cannot_be_blank
    errors.add(:customer_first_name, "can't be blank") if blank_first_name
  end

  def customer_last_name_cannot_be_blank
    errors.add(:customer_last_name, "can't be blank") if blank_last_name
  end

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
    return unless self.location and ['Walmart', 'Micro Center'].include?(self.location.channel.name)
    if whole_home_kit_without_gift_card_number
      errors.add(:gift_card_number, "must be entered if you have selected the Vonage whole home kit")
    end
  end

end
