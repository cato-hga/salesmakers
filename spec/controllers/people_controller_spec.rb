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

  describe 'GET csv' do
    it 'returns a success status for CSV format' do
      get :csv,
          format: :csv
      expect(response).to be_success
    end

    it 'redirects an HTML format' do
      get :csv
      expect(response).to redirect_to(people_path)
    end
  end

  describe 'GET new_sms_message' do
    let(:person) { Person.first }
    before { get :new_sms_message, id: person.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new_sms_message template' do
      expect(response).to render_template(:new_sms_message)
    end
  end

  describe 'POST create_sms_message', vcr: true do
    let(:person) { Person.first }

    it 'creates a log entry' do
      expect{
        post :create_sms_message, id: person.id, contact_message: 'Test message'
      }.to change(LogEntry, :count).by(1)
    end

    it "redirects to the person's page" do
      post :create_sms_message, id: person.id, contact_message: 'Test message'
      expect(response).to redirect_to(person_path(person))
    end
  end
end