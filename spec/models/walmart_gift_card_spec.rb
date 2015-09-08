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

require 'rails_helper'

describe WalmartGiftCard do
  subject { build :walmart_gift_card }

  it 'validates links properly' do
    subject.link = 'htt'
    expect(subject).not_to be_valid
    subject.link = 'http://'
    expect(subject).not_to be_valid
    subject.link = 'http://www.walmart.com'
    expect(subject).not_to be_valid
    subject.link = 'http://www.walmart.com/s'
    expect(subject).to be_valid
    subject.link = 'https://www.walmart.com/s'
    expect(subject).to be_valid
  end

  it 'validates PIN numbers properly' do
    subject.pin = '0'*3
    expect(subject).not_to be_valid
    subject.pin = '0'*5
    expect(subject).not_to be_valid
    subject.pin = 'a'*4
    expect(subject).not_to be_valid
    subject.pin = '0'*4
    expect(subject).to be_valid
  end

  it 'validates that the purchase date is today or earlier' do
    subject.purchase_date = Date.tomorrow
    expect(subject).not_to be_valid
    subject.purchase_date = Date.today
    expect(subject).to be_valid
    subject.purchase_date = Date.yesterday
    expect(subject).to be_valid
  end

  it 'validates the uniqueness of the card number' do
    create :walmart_gift_card, card_number: subject.card_number
    expect(subject).not_to be_valid
  end

  describe 'online card checks', :vcr do

    context 'with a challenge code' do
      let(:gift_card) {
        WalmartGiftCard.new link: 'https://getegiftcard.walmart.com/gift-card/view/adnDrpbztK3wINMQLZ1WNDXY2/',
                            challenge_code: 'EdCbbV'
      }

      before { gift_card.check }

      it 'has the correct card details' do
        expect(gift_card.card_number).to eq('6084819554713873')
        expect(gift_card.pin).to eq('9661')
        expect(gift_card.balance).to eq(0.93)
        expect(gift_card.purchase_date).to eq(Date.new(2014, 3, 8))
        expect(gift_card.purchase_amount).to eq(87.07)
        expect(gift_card.store_number).to eq('5457')
        expect(gift_card.used).to eq(true)
      end
    end

    context 'without a challenge code for cards already imported' do
      let(:gift_card) {
        WalmartGiftCard.new link: 'https://getegiftcard.walmart.com/gift-card/view/adnDrpbztK3wINMQLZ1WNDXY2/',
                            challenge_code: 'EdCbbV'
      }

      before do
        gift_card.check
        gift_card.balance = 60.00
        gift_card.purchase_date = nil
        gift_card.purchase_amount = nil
        gift_card.store_number = nil
        gift_card.used = false
        gift_card.save
      end

      it 'retrieves balance and history' do
        existing_gift_card = WalmartGiftCard.new link: 'https://getegiftcard.walmart.com/gift-card/view/adnDrpbztK3wINMQLZ1WNDXY2/'
        existing_gift_card.check
        expect(existing_gift_card.card_number).to eq('6084819554713873')
        expect(existing_gift_card.pin).to eq('9661')
        expect(existing_gift_card.balance).to eq(0.93)
        expect(existing_gift_card.purchase_date).to eq(Date.new(2014, 3, 8))
        expect(existing_gift_card.purchase_amount).to eq(87.07)
        expect(existing_gift_card.store_number).to eq('5457')
        expect(existing_gift_card.used).to eq(true)
      end

      it 'does not make duplicates' do
        existing_gift_card = WalmartGiftCard.new link: 'https://getegiftcard.walmart.com/gift-card/view/adnDrpbztK3wINMQLZ1WNDXY2/'
        existing_gift_card.check
        existing_gift_card.save
        expect(WalmartGiftCard.count).to eq(1)
      end
    end
  end
end
