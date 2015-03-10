require 'rails_helper'

describe 'selecting a Location for a Candidate' do
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:position) {
    create :position,
           name: 'Advocate',
           permissions: [permission_create]
  }
  let(:recruiter) { create :person, position: position }
  let(:candidate) {
    create :candidate,
           latitude: 18.00,
           longitude: -66.40,
           project: area.project
  }
  let(:area) { create :area }
  let(:location) {
    create :location,
           latitude: 17.9857925,
           longitude: -66.3914388
  }
  let!(:location_area) {
    create :location_area,
           location: location,
           area: area,
           target_head_count: 2,
           potential_candidate_count: 1
  }

  it 'recognizes that the location is nearby the candidate' do
    nearby = Location.near(candidate)
    expect(nearby.first).to eq(location)
  end

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit select_location_candidate_path candidate
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do
    before do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit select_location_candidate_path candidate
    end

    it 'has the proper title' do
      expect(page).to have_selector('h1', text: "Select Location for #{candidate.display_name}")
    end

    it 'selects a location' do
      click_on "#{location.channel.name}, #{location.display_name}"
      expect(page).to have_content('successfully')
    end
  end
end