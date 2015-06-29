require 'rails_helper'

describe LocationsController do
  let!(:channel) { create :channel }
  let(:location) { build :location }
  let!(:area) { create :area }
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
           area_id: area.id
    end

    it 'returns a success status' do
      expect(response).to redirect_to(new_client_project_location_path(area.project.client, area.project))
    end
  end
end