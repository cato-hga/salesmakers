require 'rails_helper'

describe 'Overriding the location of candidates' do

  let(:person) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_select_location, permission_index, permission_vip] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_select_location) { Permission.new key: 'candidate_select_location',
                                                    permission_group: permission_group,
                                                    description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:permission_vip) { Permission.new key: 'candidate_vip',
                                         permission_group: permission_group,
                                         description: 'Test Description' }
  let(:location) { create :location, display_name: 'Location One' }
  let!(:location_area) { create :location_area, location: location, area: area }
  let(:area) { create :area, project: project }
  let(:project) { create :project }

  let(:location_two) { create :location, display_name: 'Location Two' }
  let!(:location_area_two) { create :location_area, location: location_two, area: area_two }
  let(:area_two) { create :area, project: project }

  let(:location_not_in_project) { create :location, store_number: '9999' }
  let!(:location_area_not_in_project) { create :location_area, location: location_not_in_project, area: area_not_in_project }
  let(:area_not_in_project) { create :area, project: project_not_in_project }
  let(:project_not_in_project) { create :project, name: 'Other Project' }

  let(:candidate) { create :candidate, location_area: location_area }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  it 'is available from candidates#show' do
    visit candidate_path(candidate)
    expect(page).to have_content 'Override Location'
  end

  it 'is only visible to those with the candidate_vip permission' do
    position.permissions.delete permission_vip
    visit candidate_path(candidate)
    expect(page).to have_content(candidate.name)
    expect(page).not_to have_content('Override Location')
  end

  context 'the page itself' do
    before(:each) do
      visit get_override_location_candidate_path(candidate)
    end
    it 'contains an index of all project locations' do
      expect(page).to have_content location.store_number
      expect(page).to have_content location_two.store_number
    end


    it 'does not include locations outside of the project' do
      expect(page).not_to have_content location_not_in_project.store_number
    end
    it 'is searchable' do
      expect(page).to have_css ('#search_form')
    end
    it 'contains an "Assign" button to assign the candidate' do
      expect(page).to have_button 'Assign', count: 2
    end
    it 'does not take recruitable logic into account' do
      allow(location).to receive(:recruitable?).and_return(false)
      expect(page).to have_content location.store_number
    end
  end

  context 'when successful' do
    before(:each) do
      visit get_override_location_candidate_path(candidate)
    end
    it 'changes the candidates location' do
      expect(candidate.location_area).to eq(location_area)
      within all('tr')[2] do
        click_on 'Assign'
      end
      candidate.reload
      expect(candidate.location_area).to eq(location_area_two)
    end
    it 'flashes a success message' do
      within all('tr')[2] do
        click_on 'Assign'
      end
      expect(page).to have_content 'Location overridden successfully'
    end
    it 'redirects to candidates#show' do
      within all('tr')[2] do
        click_on 'Assign'
      end
      expect(current_path).to eq(candidate_path(candidate))
    end
  end
end