require 'rails_helper'

describe "Terminating a Person" do

  let(:terminating_employee) { create :person }
  let(:correct_manager) { create :person, position: manager_position }
  let(:other_manager) { create :person, position: manager_position }
  let(:manager_position) { create :position, name: 'Retail Manager', permissions: [permission_terminate] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_terminate) { Permission.new key: 'person_terminate',
                                              permission_group: permission_group,
                                              description: 'Test Description' }
  let(:project) { create :project, name: 'Sprint Postpaid' }
  let(:correct_area) { create :area, project: project }
  let(:other_area) { create :area }
  let!(:terminating_employee_person_area) { create :person_area, person: terminating_employee, manages: false, area: correct_area }
  let!(:correct_person_area) { create :person_area, person: correct_manager, manages: true, area: correct_area }
  let!(:other_manager_person_area) { create :person_area, person: other_manager, manages: true, area: other_area }

  context 'via the NOS screen, for unauthorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(other_manager.email)
    end

    it 'does not show the link to the NOS screen' do
      visit person_path terminating_employee
      expect(page).not_to have_css('#nos_button')
    end

    specify 'if somehow accessed by url, does not allow access' do
      expect {
        visit terminate_person_path terminating_employee
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'via the NOS screen, for authorized users, (managers and above)' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(correct_manager.email)
      visit person_path terminating_employee
    end

    it 'sends a person to the NOS confirmation/data entry page' do
      click_on 'Terminate/NOS Person'
      expect(current_path).to eq(terminate_person_path(terminating_employee))
    end
    it 'makes the user enter the termination date, last day worked, separation reason, eligible for rehire, and any remarks' do
      click_on 'Terminate/NOS Person'
      click_on 'Send NOS'
      expect(page).to have_content 'The rehire eligibility of the employee must be selected'
      expect(page).to have_content 'A Separation Reason must be selected'
      expect(page).to have_content 'The date entered could not be used. Please double check and try to send again'
      expect(current_path).to eq(terminate_person_path(terminating_employee))
    end

    it 'generates and sends the NOS'
    it 'creates an object with the envelope guid tracked'
    it 'creates log entries (person as referencable, trackable is generated object)'
    it 'sends the correct NOS for the project'
    it 'sends the correct NOS for the state, if necessary'
    it 'does not deactivate the person or take any action'
    it 'keeps track of the generated time, and alerts if the person is still active after a few days of the NOS being generated'
  end

  context 'once HR signs the NOS' do
    it 'deactivates the person and candidate'
    it 'creates log entries'
    it 'changes the head count for the candidate/persons location'
  end
end