require 'rails_helper'

describe RosterVerificationMailer do
  let(:project) { create :project, name: 'Sprint Retail' }
  let!(:root_area) { create :area, name: 'Root Area', project: project }
  let!(:intermediate_area) { create :area, name: 'Intermediate Area', parent: root_area, project: project }
  let!(:bottom_area) { create :area, name: 'Bottom Area', parent: intermediate_area, project: project }

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
        expect(mail.body.parts.find { |p| p.content_type.match /html/ }.body.raw_source).to include '1 employee'
      end
    end
  end

  describe '#send_employee_exceptions' do
    context 'without any exceptions' do
      let(:roster_verification_session) { create :roster_verification_session, creator: manager }
      let!(:roster_verification) {
        create :roster_verification,
               status: RosterVerification.statuses[:active],
               roster_verification_session: roster_verification_session
      }

      let!(:mail) { described_class.send_employee_exceptions roster_verification.roster_verification_session }

      it 'does not send an email' do
        expect(mail.to).to be_nil
      end
    end

    context 'with exceptions' do
      let(:missing_employees) { 'John Lee Hooker, Billy Idol' }
      let(:roster_verification_session) { create :roster_verification_session, creator: manager, missing_employees: missing_employees }
      let!(:roster_verification) {
        create :roster_verification,
               status: RosterVerification.statuses[:huh],
               roster_verification_session: roster_verification_session
      }

      let!(:mail) { described_class.send_employee_exceptions roster_verification.roster_verification_session }

      it 'sends to the proper email address' do
        expect(mail.to).to include 'sprintstaffing@retaildoneright.com'
      end

      it 'has the correct subject' do
        expect(mail.subject).to include "#{manager.display_name}'s Exceptions on Roster Verification"
      end

      it 'has the names of the employees' do
        expect(mail.body.parts.find { |p| p.content_type.match /html/ }.body.raw_source).to include roster_verification.person.display_name
      end

      it 'has the email addresses of the employees' do
        expect(mail.body.parts.find { |p| p.content_type.match /html/ }.body.raw_source).to include roster_verification.person.email
      end

      it 'has the missing employee information' do
        expect(mail.body.parts.find { |p| p.content_type.match /html/ }.body.raw_source).to include missing_employees
      end
    end
  end
end