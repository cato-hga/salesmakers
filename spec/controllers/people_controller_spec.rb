require 'rails_helper'

describe PeopleController do
  let(:person) { Person.first }

  describe 'GET index' do
    it 'returns a success status' do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe 'GET org_chart' do
    it 'returns a success status' do
      get :org_chart
      expect(response).to be_success
      expect(response).to render_template(:org_chart)
    end
  end

  describe 'GET show' do
    it 'returns a success status' do
      get :show, id: person.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end

    it 'passes the correct person to the view' do
      get :show, id: person.id
      expect(assigns(:person)).to eq(person)
    end
  end

  describe 'GET sales' do
    it 'returns a success status' do
      get :sales, id: person.id
      expect(response).to be_success
      expect(response).to render_template(:sales)
    end

    it 'passes the correct person to the view' do
      get :sales, id: person.id
      expect(assigns(:person)).to eq(person)
    end
  end

  describe 'GET about' do
    it 'returns a success status', :vcr do
      get :about, id: person.id
      expect(response).to be_success
      expect(response).to render_template(:about)
    end

    it 'passes the correct person to the view', :vcr do
      get :about, id: person.id
      expect(assigns(:person)).to eq(person)
    end
  end

  describe 'PUT update' do
    let(:new_phone) { '8135544444' }

    it 'updates a person' do
      put :update,
          id: person.id,
          person: {
              mobile_phone: new_phone
          }
      expect(response).to be_redirect
      # TODO: Need a series of more robust tests as to what is/is not updating
    end
  end

  describe 'GET search' do
    it 'returns a success status' do
      get :search
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

end