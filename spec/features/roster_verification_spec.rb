require 'rails_helper'

describe 'roster verification' do
  let!(:vonage_paycheck) { create :vonage_paycheck, cutoff: Date.tomorrow.to_datetime }

  let(:employee) { create :person }
  let!(:employment) { create :employment, person: employee }
  let(:location) { create :location }
  let!(:shift) { create :shift, person: employee, date: (DateTime.now - 1.day).to_date, location: location }

  let!(:root_area) { create :area, name: 'Root Area' }
  let!(:intermediate_area) { create :area, name: 'Intermediate Area' }
  let!(:bottom_area) { create :area, name: 'Bottom Area' }

  let!(:employee_person_area) { create :person_area, area: bottom_area, person: employee }

  let(:manager) { create :person }
  let!(:manager_person_area) { create :person_area, area: root_area, person: manager, manages: true }

  before do
    intermediate_area.update parent: root_area
    bottom_area.update parent: intermediate_area
    CASClient::Frameworks::Rails::Filter.fake(manager.email)
  end

  context 'without an NOS pending' do
    before { visit new_roster_verification_session_path }

    it 'has the proper page title' do
      expect(page).to have_selector 'h1', text: 'Roster Verification'
    end

    it 'has a widget for each area' do
      expect(page).to have_selector '.widget h3', text: bottom_area.name
    end

    it 'lists employees in the area' do
      expect(page).to have_content employee.display_name
    end

    it "lists the employee's last shift date" do
      expect(page).to have_content '1 day ago'
    end

    it "lists the employee's last shift location" do
      expect(page).to have_content location.name
    end

    it 'lists the position for the employee' do
      expect(page).to have_content employee.position.name
    end

    it 'displays the employee hire date' do
      expect(page).to have_content "Hired #{employment.start.strftime('%m/%d/%Y')}"
    end

    it 'shows the total number of employees in the page heading' do
      expect(page).to have_selector 'h1 .small', text: '(1 employee, 1 with hours in the past week)'
    end

    it 'shows the total number of employees in the territory heading' do
      expect(page).to have_selector '.widget .small', text: '(1 employee, 1 with hours in the past week)'
    end
  end

  context 'when the employee has a pending NOS' do
    let!(:roster_verification) {
      create :roster_verification,
             person: employee,
             status: RosterVerification.statuses[:terminate],
             envelope_guid: '12345'
    }

    before { visit new_roster_verification_session_path }

    it 'does not show any form fields' do
      expect(page).not_to have_selector 'input[type="radio"]'
    end

    it 'shows that the person has a roster pending' do
      expect(page).to have_selector '.sm_orange', text: 'There is an NOS pending to terminate this person.'
    end
  end

  describe 'submission' do
    let!(:missing_employees) { 'John Lee Hooker, Billy Idol' }

    before do
      visit new_roster_verification_session_path
      choose 'roster_verification_session_roster_verifications_attributes_0_status_active'
      fill_in 'Missing employees', with: missing_employees
    end

    subject { click_on 'Save' }

    it 'adds a RosterVerificationSession' do
      expect {
        subject
      }.to change(RosterVerificationSession, :count).by 1
    end

    it 'saves the missing employees on the session' do
      subject
      expect(RosterVerificationSession.first.missing_employees).to eq(missing_employees)
    end

    it 'adds a RosterVerification' do
      expect {
        subject
      }.to change(RosterVerification, :count).by 1
    end
  end
end
