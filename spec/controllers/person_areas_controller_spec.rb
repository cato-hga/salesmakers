require 'rails_helper'

describe PersonAreasController do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) {
    create :it_tech_position,
           permissions: [
               person_area_create_permission,
               person_area_update_permission,
               person_area_destroy_permission
           ]
  }
  let(:person_area_create_permission) { create :permission, key: 'person_area_create' }
  let(:person_area_update_permission) { create :permission, key: 'person_area_update' }
  let(:person_area_destroy_permission) { create :permission, key: 'person_area_destroy' }
  let(:person) { create :person }

  before do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  end

  describe 'GET index' do
    before { get :index, person_id: person.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before { get :new, person_id: person.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:person_area) { build :person_area, person: person }

    subject do
      post :create,
           person_id: person.id,
           person_area: {
               area_id: person_area.area.id
           }
    end

    it 'creates the PersonArea' do
      expect {
        subject
      }.to change(PersonArea, :count).by(1)
    end

    it 'creates a LogEntry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to PersonAreas#index' do
      subject
      expect(response).to redirect_to person_person_areas_path(person)
    end
  end

  describe 'GET edit' do
    let!(:person_area) { create :person_area, person: person, manages: false }

    before do
      get :edit,
          person_id: person.id,
          id: person_area.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT update' do
    let!(:person_area) { create :person_area, person: person, manages: true }

    before do
      put :update,
          person_id: person.id,
          id: person_area.id,
          person_area: {
            area_id: person_area.area.id
          }
    end

    it 'redirects to PersonAreas#index' do
      expect(response).to redirect_to(person_person_areas_path(person))
    end

    it 'changes the PersonArea' do
      person_area.reload
      expect(person_area.manages?).to eq(false)
    end
  end

  describe 'DELETE destroy' do
    let!(:person_area) { create :person_area, person: person, manages: true }

    subject do
      delete :destroy,
          person_id: person.id,
          id: person_area.id
    end

    it 'redirects to PersonAreas#index' do
      subject
      expect(response).to redirect_to(person_person_areas_path(person))
    end

    it 'destroys the PersonArea' do
      expect {
        subject
      }.to change(PersonArea, :count).by(-1)
    end
  end
end