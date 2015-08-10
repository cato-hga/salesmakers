require 'rails_helper'

describe 'edit candidate details' do
  let!(:candidate) { create :candidate,
                            shirt_size: 'M',
                            shirt_gender: 'Female',
                            training_availability: available,
                            location_area: location_area

  }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let!(:reason) { create :training_unavailability_reason }
  let!(:available) { create :training_availability, able_to_attend: false, training_unavailability_reason: reason }
  let(:location_area) { create :location_area }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidate_path candidate
    within('.widget.candidate_details') do
      click_on 'Edit'
    end
  end

  it 'shows the confirm page' do
    expect(page).to have_content 'Shirt Information'
    expect(page).to have_content 'Training Attendance'
  end

  describe 'form submission' do
    subject do
      select 'Male', from: 'Gender'
      select 'L', from: 'Shirt size'
      select 'Yes', from: 'Is the candidate able to attend the training?'
      click_on 'Update Details'
      candidate.reload
    end
    it 'updates the candidates details' do
      expect(candidate.shirt_size).to eq('M')
      expect(candidate.shirt_gender).to eq('Female')
      expect(candidate.training_availability.able_to_attend).to eq(false)
      subject
      expect(candidate.shirt_size).to eq('L')
      expect(candidate.shirt_gender).to eq('Male')
      expect(candidate.training_availability.able_to_attend).to eq(true)
    end
    it 'redirects to candidate#show' do
      subject
      expect(page).to have_content candidate.name
    end
    it 'creates a log entry' do
      subject
      log = LogEntry.first
      expect(page).to have_content "Updated #{log.trackable.first_name} #{log.trackable.last_name}"
    end
    it 'flashes a success message' do
      subject
      expect(page).to have_content 'Candidate updated'
    end
  end
end