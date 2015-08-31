require 'rails_helper'

describe WalmartGiftCardMailer do
  describe '#unmatched_sales' do
    let(:person) { create :person }
    let(:walmart_gift_card) { create :walmart_gift_card }
    let!(:developer) { create :person, position: senior_developer_position }
    let(:senior_developer_position) { create :position, name: 'Senior Software Developer' }
    let(:mail) { described_class.send_card_details [walmart_gift_card], person }

    it 'sends an email with the correct subject' do
      expect(mail.subject).to include('Walmart Gift Card Details')
    end

    it 'sends an email to the checker' do
      expect(mail.to).to include(person.email)
    end

    it 'sends an email to the senior developer' do
      expect(mail.to).to include(developer.email)
    end

    it 'sends an email with the correct "from" address' do
      expect(mail.from).to include('giftcards@retaildoneright.com')
    end

    it 'does not send an email given no gift cards' do
      expect {
        described_class.send_card_details([], person).deliver_later
      }.not_to change(ActionMailer::Base.deliveries, :count)
    end

    it 'attaches a file' do
      expect(mail.attachments.count).to eq(1)
    end

  end
end