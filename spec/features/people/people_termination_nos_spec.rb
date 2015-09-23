require 'rails_helper'

describe "Terminating a Person" do
  let(:terminating_employee) { create :person }
  let!(:candidate) { create :candidate, person: terminating_employee }
  let(:correct_manager) { create :person, position: manager_position }
  let(:other_manager) { create :person, position: other_manager_position }
  let(:manager_position) { create :position, name: 'Retail Manager', permissions: [permission_terminate] }
  let(:other_manager_position) { create :position, name: 'Other Manager' }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_terminate) { Permission.new key: 'person_terminate',
                                              permission_group: permission_group,
                                              description: 'Test Description' }
  let(:project) { create :project, name: 'STAR' }
  let(:other_project) { create :project, name: 'Vonage' }
  let(:correct_area) { create :area, project: project }
  let(:other_area) { create :area, project: other_project }
  let!(:terminating_employee_person_area) { create :person_area, person: terminating_employee, manages: false, area: correct_area }
  let!(:correct_person_area) { create :person_area, person: correct_manager, manages: true, area: correct_area }
  let!(:other_manager_person_area) { create :person_area, person: other_manager, manages: true, area: other_area }
  let!(:reason) { create :employment_end_reason }

  context 'via the NOS screen, for unauthorized users' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(other_manager.email)
    end

    it 'does not show the link to the NOS screen' do
      visit person_path terminating_employee
      expect(page).not_to have_css('#nos_button')
    end

    specify 'if somehow accessed by url, does not allow access' do
      visit new_person_docusign_nos_path terminating_employee
      expect(page).to have_content 'Your access does not allow you to view this page'
    end
  end

  context 'via the NOS screen, for authorized users, (managers and above)' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(correct_manager.email)
      visit person_path terminating_employee
    end

    it 'sends a person to the NOS confirmation/data entry page' do
      click_on 'Terminate/NOS Person'
      expect(current_path).to eq(new_person_docusign_nos_path(terminating_employee))
    end
    it 'makes the user enter the termination date, last day worked, separation reason, eligible for rehire, and any remarks' do
      click_on 'Terminate/NOS Person'
      click_on 'Send NOS'
      expect(page).to have_content 'Eligible to rehire must be selected'
      expect(page).to have_content 'Separation reason must be selected'
      expect(page).to have_content 'Termination date entered could not be used or is blank. Please double check and try again'
      expect(page).to have_content 'Last day worked entered could not be used or is blank. Please double check and try again'
    end

    context 'successful sending' do
      before(:each) do
        click_on 'Terminate/NOS Person'
        fill_in :docusign_nos_termination_date, with: 'today'
        fill_in :docusign_nos_last_day_worked, with: 'today'
        select reason.name, from: :docusign_nos_employment_end_reason_id
        select "No", from: :docusign_nos_eligible_to_rehire
        click_on 'Send NOS'
      end

      it 'creates an object with the envelope guid tracked', :vcr do
        expect(page).to have_content 'NOS form sent'
      end
      it 'creates log entries (person as referencable, trackable is generated object)', :vcr do
        visit person_path terminating_employee
        expect(page).to have_content 'Initiated a notice of separation'
      end
      it 'does not deactivate the person or take any action', :vcr do
        terminating_employee.reload
        expect(terminating_employee.active).to eq(true)
      end
      it 'changes the Candidate training session status' do
        candidate.reload
        expect(candidate.training_session_status).to eq('nos')
      end
    end
  end

  context 'via the NOS screen, for authorized users, (SalesMaker Support Members)' do
    let(:sms) { create :person, position: sms_position }
    let(:sms_position) { create :position, name: 'SalesMakers Support Member' }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(sms.email)
      visit person_path terminating_employee
    end

    it 'sends a person to the NOS confirmation/data entry page' do
      click_on 'Send NOS to SD'
      expect(current_path).to eq(new_third_party_person_docusign_noses_path(terminating_employee))
    end
    it 'makes the user select a manager' do
      click_on 'Send NOS to SD'
      click_on 'Send NOS'
      expect(page).to have_content 'A manager must be selected'
    end

    context 'successful sending' do
      before(:each) do
        click_on 'Send NOS to SD'
        select correct_manager.name, from: :docusign_nos_manager
        click_on 'Send NOS'
      end

      it 'creates an object with the envelope guid tracked', :vcr do
        expect(page).to have_content 'NOS form initiated'
      end
      it 'creates log entries (person as referencable, trackable is generated object)', :vcr do
        expect(LogEntry.count).to eq(1)
        expect(LogEntry.first.action).to eq 'sent_nos'
      end

      it 'does not deactivate the person or take any action', :vcr do
        terminating_employee.reload
        expect(terminating_employee.active).to eq(true)
      end

      it 'changes the Candidate training session status' do
        candidate.reload
        expect(candidate.training_session_status).to eq('nos')
      end
    end
  end
end