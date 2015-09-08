require 'rails_helper'

describe LocationsController do
  let!(:channel) { create :channel }
  let(:location) { build :location }
  let!(:area) { create :area }
  let!(:client_area) { create :client_area, project: area.project }
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [location_create_permission, location_index_permission] }
  let(:location_create_permission) { create :permission, key: 'location_create' }
  let(:location_index_permission) { create :permission, key: 'location_index' }

  describe 'GET index' do
    before do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      get :index,
          client_id: area.project.client.id,
          project_id: area.project.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET csv' do
    let!(:location_area) { create :location_area, location: location, area: area }

    before { CASClient::Frameworks::Rails::Filter.fake(person.email) }

    it 'returns a success status for CSV format' do
      get :csv,
          client_id: area.project.client.id,
          project_id: area.project.id,
          format: :csv
      expect(response).to be_success
    end

    it 'redirects an HTML format' do
      get :csv,
          client_id: area.project.client.id,
          project_id: area.project.id
      expect(response).to redirect_to(client_project_locations_path(area.project.client, area.project))
    end
  end

  describe 'GET show' do
    before do
      location.save
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      get :show,
          client_id: area.project.client.id,
          project_id: area.project.id,
          id: location.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET new' do
    before do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      get :new,
          client_id: area.project.client.id,
          project_id: area.project.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do

    before do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      post :create,
           client_id: area.project.client.id,
           project_id: area.project.id,
           location: {
               channel_id: channel.id,
               store_number: location.store_number,
               display_name: location.display_name,
               street_1: location.street_1,
               city: location.city,
               state: location.state,
               zip: location.zip
           },
           area_id: area.id,
           client_area_id: client_area.id
    end

    it 'returns a success status' do
      expect(response).to redirect_to(new_client_project_location_path(area.project.client, area.project))
    end
  end

  describe 'GET edit_head_counts' do
    let(:person) { create :person }
    let(:client) { create :client }
    let(:project) { create :project, client: client }
    before :each do
      allow(controller).to receive(:policy).and_return(double(edit_head_counts?: true))
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      get :edit_head_counts,
          client_id: client.id,
          project_id: project.id

    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:edit_head_counts)
    end

  end

  describe 'POST update_head_counts' do
    let(:person) { create :person }
    let(:location_one) { create :location, store_number: '1111' }
    let(:location_two) { create :location, store_number: '2222' }
    let!(:location_area_one) { create :location_area, location: location_one, area: area, target_head_count: 0, priority: 2 }
    let!(:location_area_two) { create :location_area, location: location_two, area: area, target_head_count: 1, priority: 2 }
    let!(:location_area_three) { create :location_area, location: location_two, area: other_area, target_head_count: 2, priority: 3 }
    let(:area) { create :area, project: project }
    let(:other_area) { create :area, name: 'Wrong area', project: other_project }
    let(:client) { create :client }
    let(:project) { create :project, client: client }
    let(:other_project) { create :project, name: 'Wrong project' }
    let(:json) {
      {
          data: [
              [
                  "1111",
                  "3",
                  "1",
              ],
              [
                  "2222",
                  "-1",
                  "3"
              ],
              [nil, nil, nil, nil, nil]
          ]
      }.to_json
    }

    subject {
      allow(controller).to receive(:policy).and_return(double(update_head_counts?: true))
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      patch :update_head_counts,
            client_id: client.id,
            project_id: project.id,
            head_count_json: json
    }

    it 'updates the correct number of stores' do
      subject
      expect(assigns(:head_count_attributes).count).to eq(2)
    end

    it 'updates the head counts and priorities for the entered locations' do
      expect(location_area_one.target_head_count).to eq(0)
      expect(location_area_two.target_head_count).to eq(1)
      expect(location_area_one.priority).to eq(2)
      expect(location_area_two.priority).to eq(2)
      subject
      location_area_one.reload
      location_area_two.reload
      expect(location_area_one.target_head_count).to eq(3)
      expect(location_area_one.priority).to eq(1)
      expect(location_area_two.priority).to eq(3)
    end

    it 'does not accept negative numbers for head count - and sets them to 0' do
      expect(location_area_two.target_head_count).to eq(1)
      subject
      location_area_two.reload
      expect(location_area_two.target_head_count).to eq(0)
    end

    it 'redirects to the location index screen after completion' do
      subject
      expect(response).to redirect_to client_project_locations_path(client, project)
    end

    it 'does not affect other location areas with the same location' do
      expect(location_area_three.target_head_count).to eq(2)
      expect(location_area_three.priority).to eq(3)
      subject
      location_area_three.reload
      expect(location_area_three.target_head_count).to eq(2)
      expect(location_area_three.priority).to eq(3)
    end

    it 'displays a flash message upon completion' do
      subject
      expect(flash[:notice]).to include 'Head counts updated for entered Locations'
    end
  end
end
