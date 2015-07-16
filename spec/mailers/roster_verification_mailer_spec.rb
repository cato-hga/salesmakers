require 'rails_helper'

describe RosterVerificationMailer do
  let!(:root_area) { create :area, name: 'Root Area' }
  let!(:intermediate_area) { create :area, name: 'Intermediate Area', parent: root_area }
  let!(:bottom_area) { create :area, name: 'Bottom Area', parent: intermediate_area }

  let(:manager) { create :person }
  let!(:manager_person_area) { create :person_area, area: root_area, person: manager, manages: true }

  describe '#send_notification_and_link' do
    context 'with no employees' do
      let(:mail) { described_class.send_notification_and_link(manager) }

      it 'does not send an email' do
        expect(mail.to).to be_nil
      end
    end

    context 'with employees' do
      let(:employee) { create :person }
      let!(:employee_person_area) { create :person_area, area: bottom_area, person: employee }

      let!(:mail) { described_class.send_notification_and_link(manager) }

      it 'sends an email to the manager' do
        expect(mail.to).to include manager.email
      end

      it 'has the correct subject' do
        expect(mail.subject).to include 'Please Verify Your Roster'
      end

      it 'has the number of employees in the email' do
        expect(mail.body.parts.find {|p| p.content_type.match /html/}.body.raw_source).to include '1 employee'
      end
    end
  end
end