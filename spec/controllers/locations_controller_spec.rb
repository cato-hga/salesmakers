require 'rails_helper'

describe LocationsController do
  let!(:channel) { create :channel }
  let(:location) { build :location }
  let!(:area) { create :area }
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [location_create_permission] }
  let(:location_create_permission) { create :permission, key: 'location_create' }

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