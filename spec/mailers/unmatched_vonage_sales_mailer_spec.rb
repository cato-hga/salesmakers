require 'rails_helper'

describe UnmatchedVonageSalesMailer do
  describe '#unmatched_sales' do
    let(:unmatched_sales) {
      [
          {
              order: build_stubbed(:connect_order,
                                   connect_user: build_stubbed(:connect_user)),
              reason: 'Person cannot be blank'
          },
          {
              order: build_stubbed(:connect_order,
                                   connect_user: build_stubbed(:connect_user),
                                   documentno: 'VONABCDEF654321+'),
              reason: 'Vonage product cannot be blank'
          }
      ]
    }
    let(:position) { create :position, name: 'Senior Software Developer' }
    let!(:person) { create :person, position: position }
    let(:mail) { UnmatchedVonageSalesMailer.unmatched_sales(unmatched_sales) }

    it 'sends an email with the correct subject' do
      expect(mail.subject).to include('Unmatched Vonage Sales on Import')
    end

    it 'sends an email to developers' do
      expect(mail.to).to include(person.email)
    end

    it 'sends an email with the correct "from" address' do
      expect(mail.from).to include('development@retaildoneright.com')
    end

    it 'does not send an email given no sales unmatched' do
      expect {
        UnmatchedVonageSalesMailer.unmatched_sales([]).deliver_later
      }.not_to change(ActionMailer::Base.deliveries, :count)
    end

    it 'includes all MACs' do
      expect(mail.body).to include(unmatched_sales.first[:order].documentno[3..14])
      expect(mail.body).to include(unmatched_sales.last[:order].documentno[3..14])
    end
  end
end