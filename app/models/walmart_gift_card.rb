require 'walmart_gift_cards/checks'

class WalmartGiftCard < ActiveRecord::Base
  include WalmartGiftCards::Checks

  validates :used, inclusion: { in: [true, false] }
  validates :card_number, length: { is: 16 }
  validates :link, format: /\Ahttps?:\/\/.*\..*\....?\/.+\z/
  validates :pin, format: /\A[0-9]{4}\z/
  validates :balance, numericality: { greater_than_or_equal_to: 0.0 }
  validate :purchase_today_or_earlier, if: :purchase_date
  validates :purchase_amount, numericality: { greater_than_or_equal_to: 0.0 }, allow_blank: true
  validates :overridden, inclusion: { in: [true, false] }

  belongs_to :vonage_sale

  private

  def purchase_today_or_earlier
    if self.purchase_date > Date.today
      errors.add :purchase_date, 'cannot be in the future'
    end
  end
end
