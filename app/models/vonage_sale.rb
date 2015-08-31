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

  attr_accessor :import

  before_save do
    if self.valid? && !self.persisted?
      VonageSale.where(mac: self.mac).each do |sale|
        sale.update resold: true
      end
    end
  end

  validates :sale_date, presence: true
  validate :sale_date_cannot_be_more_than_2_weeks_in_the_past
  validates :person, presence: true
  validates :confirmation_number, length: { is: 10 }
  validates :location, presence: true
  validates :customer_first_name, format: { with: /\A[a-zA-Z_\-]+\z/i }, unless: :blank_first_name
  validate :customer_first_name_cannot_be_blank
  validates :customer_last_name, format: { with: /\A[a-zA-Z_\-]+\z/i }, unless: :blank_last_name
  validate :customer_last_name_cannot_be_blank
  validates :mac, format: { with: /\A[0-9A-F]{12}\z/i }, confirmation: true
  validates :vonage_product, presence: true
  validates :gift_card_number, format: { with: /\A([0-9A-Z]{16}|[0-9A-Z]{12})\z/i }, confirmation: true, if: :home_kit_with_gift_card_number?
  validate :gift_card_number_required_for_whole_home_kit
  validates :person_acknowledged, acceptance: { accept: true, message: 'gift card rules and regulations must be checked.' }
  validate :mac_prefix_valid
  validates :creator, presence: true
  validate :gift_card_used, unless: :override_card
  validate :mac_not_sold_on_same_day

  belongs_to :person
  belongs_to :creator, class_name: 'Person'
  belongs_to :location
  belongs_to :vonage_product
  belongs_to :connect_order, foreign_key: 'connect_order_uuid'

  has_many :vonage_sale_payouts
  has_one :vonage_refund
  has_many :vonage_account_status_changes, primary_key: 'mac', foreign_key: 'mac'
  has_one :vcp07012015_hps_sale
  has_one :walmart_gift_card, primary_key: 'card_number', foreign_key: 'gift_card_number'

  strip_attributes

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

  def import?
    return false unless self.import
    true
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
    errors.add(:sale_date, "cannot be dated for more than 2 weeks in the past") if sale_date and sale_date <= 2.weeks.ago && !import?
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

  def override_card
    return false if import? || !self.gift_card_number
    override_card = GiftCardOverride.find_by override_card_number: self.gift_card_number
    return false unless override_card
    existing_sales = VonageSale.where(gift_card_number: self.gift_card_number)
    if existing_sales.count > 0
      errors.add :gift_card_number, 'has already been used as an override before.'
    end
    true
  end

  def gift_card_used
    return if import? || !self.gift_card_number
    return unless self.location and self.location.channel.name == 'Walmart'
    gift_card = WalmartGiftCard.find_by card_number: self.gift_card_number
    unless gift_card
      errors.add(:gift_card_number, 'has not yet been imported.')
      return
    end
    gift_card.check
    unless gift_card.used?
      errors.add(:gift_card_number, 'has not been used.')
      return
    end
    if gift_card.vonage_sale
      errors.add(:gift_card_number, 'is already associated with MAC ID ' + gift_card.vonage_sale.mac)
      return
    end
    validate_gift_card_location gift_card
  end

  def validate_gift_card_location gift_card
    return unless self.location and gift_card.store_number
    unless self.location.store_number == gift_card.store_number
      errors.add(:location, 'selected is #' + self.location.store_number + ' but the gift card was used at #' + gift_card.store_number)
    end
  end

  def mac_not_sold_on_same_day
    return unless self.mac && self.sale_date && !self.persisted?
    unless VonageSale.where(sale_date: self.sale_date, mac: self.mac).empty?
      errors.add :mac, 'has already been entered as a sale on the same day'
    end
  end
end
