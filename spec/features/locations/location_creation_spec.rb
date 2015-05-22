require 'rails_helper'

describe 'creating Locations and LocationAreas' do
  let(:location) { build :location }
  let!(:area) { create :area }
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [location_create_permission] }
  let(:location_create_permission) { create :permission, key: 'location_create' }
  let!(:channel) { create :channel }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    visit new_client_project_location_path(area.project.client, area.project)
  end

  it 'creates a Location' do
    select channel.name, from: 'Channel'
    fill_in 'Store number', with: location.store_number
    fill_in 'Display name', with: location.display_name
    fill_in 'Street address line 1', with: location.street_1
    fill_in 'City', with: location.city
    select location.state, from: 'State'
    fill_in 'ZIP Code', with: location.zip
    select area.name, from: 'Area'
    fill_in 'Priority', with: '1'
    fill_in 'Target head count', with: '2'
    click_on 'Save'
    expect(page).to have_content('successfully')
    expect(Location.count).to eq(1)
    expect(LocationArea.count).to eq(1)
    expect(LocationArea.first.priority).to eq(1)
    expect(LocationArea.first.target_head_count).to eq(2)
  end
end