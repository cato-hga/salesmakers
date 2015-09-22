require 'rails_helper'

describe 'The Location Head Count Updater' do

  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [update_permission, index_permission] }
  let(:index_permission) { Permission.create key: 'location_update', permission_group: permission_group, description: description }
  let(:update_permission) { Permission.create key: 'location_index', permission_group: permission_group, description: description }
  let(:permission_group) { create :permission_group, name: 'Locations' }
  let(:description) { 'Test Description' }
  let(:location_one) { create :location, store_number: '1111' }
  let(:location_two) { create :location, store_number: '2222' }
  let(:location_area_one) { create :location_area, location: location_one, area: area, target_head_count: 0, priority: 2 }
  let(:location_area_two) { create :location_area, location: location_two, area: area, target_head_count: 0, priority: 2 }
  let(:area) { create :area, project: project }
  let(:client) { create :client }
  let(:project) { create :project, client: client }


  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }
    let(:unauth_position) { create :position, permissions: [index_permission] }
    before :each do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
    end

    it 'is not seen on the location screen' do
      visit client_project_locations_path(project.client, project)
      expect(page).not_to have_content 'Update Head Counts'
    end
    it 'denies access if visited directly' do
      visit edit_head_counts_client_project_locations_path(project.client, project)
      expect(page).to have_content 'Your access does not allow you to view this page'
    end
  end

  describe 'for authorized users' do
    before :each do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
    end
    it 'is available from the STAR "Locations" screen' do
      visit client_project_locations_path(project.client, project)
      expect(page).to have_content 'Update Head Counts'
    end

    describe 'the edit head counts page' do
      before :each do
        visit edit_head_counts_client_project_locations_path(project.client, project)
      end

      it 'contains a grid with a prompt for the copy and paste' do
        expect(page).to have_button 'Save'
      end
    end
  end
end