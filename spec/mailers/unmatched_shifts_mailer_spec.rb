require 'rails_helper'

describe UnmatchedShiftsMailer do
  describe '#unmatched_shifts' do
    let(:unmatched_shifts) {
      [
          {
              timesheet: build_stubbed(:connect_blueforce_timesheet,
                                   connect_user: build_stubbed(:connect_user)),
              reason: 'Person cannot be blank'
          },
          {
              timesheet: build_stubbed(:connect_timesheet,
                                   shift_date: Date.today - 3.days,
                                   connect_user: build_stubbed(:connect_user)),
              reason: 'Person cannot be blank'
          }
      ]
    }
    let(:position) { create :position, name: 'Senior Software Developer' }
    let!(:person) { create :person, position: position }
    let(:mail) { described_class.unmatched_shifts(unmatched_shifts) }

    it 'sends an email with the correct subject' do
      expect(mail.subject).to include('Unmatched Shifts on Import')
    end

    it 'sends an email to developers' do
      expect(mail.to).to include(person.email)
    end

    it 'sends an email with the correct "from" address' do
      expect(mail.from).to include('development@retaildoneright.com')
    end

    it 'does not send an email given no shifts unmatched' do
      expect {
        described_class.unmatched_shifts([]).deliver_later
      }.not_to change(ActionMailer::Base.deliveries, :count)
    end

    it 'includes all shift dates' do
      expect(mail.body).to include(unmatched_shifts.first[:timesheet].shift_date.strftime('%m/%d/%Y'))
      expect(mail.body).to include(unmatched_shifts.last[:timesheet].shift_date.strftime('%m/%d/%Y'))
    end
  end

end