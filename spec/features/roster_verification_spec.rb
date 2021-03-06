require 'rails_helper'

describe 'roster verification' do
  let!(:vonage_paycheck) { create :vonage_paycheck, cutoff: Date.tomorrow.to_datetime }

  let(:department) { create :department, name: 'Foobar Department' }
  let(:position) { create :position, name: 'Foobar Position', department: department }
  let(:employee) { create :person }
  let!(:employment) { create :employment, person: employee }
  let(:location) { create :location }
  let!(:shift) { create :shift, person: employee, date: (DateTime.now - 1.day).to_date, location: location }

  let!(:root_area) { create :area, name: 'Root Area' }
  let!(:intermediate_area) { create :area, name: 'Intermediate Area' }
  let!(:bottom_area) { create :area, name: 'Bottom Area' }

  let!(:employee_person_area) { create :person_area, area: bottom_area, person: employee }

  let(:manager) { create :person, display_name: 'Billy Joel', position: position }
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

  context 'when the employee has a candidate record with a future training session' do
    let!(:sprint_radio_shack_training_session) {
      create :sprint_radio_shack_training_session, start_date: Date.today + 1.day
    }
    let!(:candidate) { create :candidate, person: employee, sprint_radio_shack_training_session: sprint_radio_shack_training_session }

    before { visit new_roster_verification_session_path }

    it 'does not show any form fields' do
      expect(page).not_to have_selector 'input[type="radio"]'
    end

    it 'shows that the person has a roster pending' do
      expect(page).to have_selector '.sm_green', text: 'This person has a future training date.'
    end

    it 'saves' do
      click_on 'Save'
      expect(RosterVerification.first.active?).to eq(true)
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

  describe 'masquerading as another manager' do
    let(:intermediate_manager) { create :person, display_name: 'Joe Schmoe' }
    let!(:intermediate_manager_person_area) { create :person_area, area: intermediate_area, person: intermediate_manager, manages: true }

    before { visit new_roster_verification_session_path }

    it 'does not have the employee until switching to masquerade' do
      expect(page).not_to have_content employee.display_name
    end

    it 'has the current person in the "Verify for manager" drop-down' do
      expect(page).to have_selector 'option', text: manager.display_name
    end

    it 'has managers under the manger in the "Verify for manager" drop-down' do
      expect(page).to have_selector 'option', text: intermediate_manager.display_name
    end

    context 'after switching to another manager' do
      before do
        select intermediate_manager.display_name, from: 'manager_id'
        click_on 'Switch'
      end

      it 'has the correct title when masquerading' do
        expect(page).to have_selector 'h1', text: "#{intermediate_manager.display_name}'s Roster Verification (1 employee, 1 with hours in the past week)"
      end

      it 'has the employee listed' do
        expect(page).to have_content employee.display_name
      end
    end
  end
end
