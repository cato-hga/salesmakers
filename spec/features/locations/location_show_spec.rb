require 'rails_helper'

describe 'showing Locations' do
  let(:location) { create :location, channel: channel }
  let!(:area) { create :area }
  let!(:location_area) { create :location_area, location: location, area: area, target_head_count: 2, priority: 1 }
  let!(:location_candidate) { create :candidate, location_area: location_area, status: :paperwork_sent }
  let!(:candidate_job_offer_detail) { create :job_offer_detail, candidate: location_candidate, sent: Date.today }
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [location_show_permission] }
  let(:location_show_permission) { create :permission, key: 'location_show' }
  let!(:channel) { create :channel }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    visit client_project_location_path(area.project.client, area.project, location)
  end

  # I've combined the expectations to make the test faster
  it 'shows the proper fields' do
    expect(page).to have_content(channel.name)
    expect(page).to have_content(location.display_name)
    expect(page).to have_content(location.street_1)
    expect(page).to have_content(location.city)
    expect(page).to have_content(location.state)
    expect(page).to have_content(location.zip)
    expect(page).to have_content(area.name)
    expect(page).to have_content('2') # target head count
  end

end