require 'rails_helper'

describe 'Candidate location information' do

  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission, permission_two] }
  let!(:location_area) { create :location_area, location: location }
  let(:location) { create :location, sprint_radio_shack_training_location: training_location }
  let(:training_location) { create :sprint_radio_shack_training_location, latitude: 40, longitude: 50 }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_two) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let!(:paperwork_sent_candidate) {
    create :candidate,
           mobile_phone: '1111111117',
           status: :paperwork_sent,
           location_area: location_area
  }
  let!(:job_offer_detail) {
    create :job_offer_detail,
           candidate: paperwork_sent_candidate,
           sent: Time.now
  }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidate_path paperwork_sent_candidate
  end

  it 'should show the location address' do
    expect(page).to have_content(location_area.location.address)
  end

  it 'should show the "Change Location" button' do
    expect(page).to have_selector('a', text: 'Change Location')
  end

  it 'does not show an option for non-confirmed candidates with training coords' do
    expect(page).not_to have_content("Candidate can't make training due to distance?")
  end

  context 'for candidates past confirmation' do
    it 'shows an option for confirmed candidates with training coords' do
      visit candidate_path paperwork_sent_candidate
      expect(page).to have_button("Candidate can't make training due to distance?")
    end

    describe 'when a candidate cannot make training due to location' do
      let!(:cant_make_location) { create :training_unavailability_reason, name: "Can't Make Training Location" }
      it 'registers a training unavailability reason' do
        click_button "Candidate can't make training due to distance?"
        paperwork_sent_candidate.reload
        expect(TrainingAvailability.count).to be(1)
        available = TrainingAvailability.first
        available.reload
        candidate_reason = available.training_unavailability_reason
        expect(candidate_reason).to eq(cant_make_location)
        expect(paperwork_sent_candidate.training_availability).to eq(TrainingAvailability.first)
      end

      it 'redirects to candidate#show and flashes a message' do
        click_button "Candidate can't make training due to distance?"
        expect(page).to have_content "Candidate marked as not being able to make their training location"
      end
    end
  end
end
