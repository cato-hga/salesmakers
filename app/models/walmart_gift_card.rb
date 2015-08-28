# == Schema Information
#
# Table name: walmart_gift_cards
#
#  id              :integer          not null, primary key
#  used            :boolean          default(FALSE), not null
#  card_number     :string           not null
#  link            :string           not null
#  challenge_code  :string           not null
#  unique_code     :string
#  pin             :string           not null
#  balance         :float            default(0.0), not null
#  purchase_date   :date
#  purchase_amount :float
#  store_number    :string
#  vonage_sale_id  :integer
#  overridden      :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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

  def self.to_csv
    attributes = %w{used link challenge_code unique_code card_number pin balance purchase_date purchase_amount store_number}

    CSV.generate(headers: true) do |csv|
      csv << [
          'SalesMakers Link',
          'Used?',
          'Links',
          'Challenge Code',
          'Unique Code',
          'Card Number',
          'PIN',
          'Balance',
          'Purchase Date',
          'Purchase Amount',
          'Store Number',
          'MAC ID',
          'SalesMaker'
      ]

      all.each do |gift_card|
        csv_atts = []
        csv_atts << gift_card.link.sub('https://getegiftcard.walmart.com/gift-card/view/', 'http://rbdconnect.com/gc/l/?link=')
        csv_atts.concat attributes.map{ |attr| gift_card.send attr }
        csv_atts[5] = "'" + csv_atts[5]
        if gift_card.vonage_sale
          csv_atts << gift_card.vonage_sale.mac
          csv_atts << gift_card.vonage_sale.person.display_name
        else
          csv_atts.concat [nil,nil]
        end

        csv << csv_atts
      end
    end
  end

  private

  def purchase_today_or_earlier
    if self.purchase_date > Date.today
      errors.add :purchase_date, 'cannot be in the future'
    end
  end
end
