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

  describe 'online card checks', :vcr do
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

end