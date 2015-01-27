require 'rails_helper'

describe PeopleController do

  describe 'GET index' do
    it 'returns a success status' do
      allow(controller).to receive(:policy).and_return double(index?: true)
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
    let!(:person) { create :it_tech_person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      allow(controller).to receive(:policy).and_return double(show?: true)
    end
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
    let!(:person) { create :it_tech_person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      allow(controller).to receive(:policy).and_return double(sales?: true)
    end
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
    let!(:person) { create :it_tech_person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      allow(controller).to receive(:policy).and_return double(about?: true)
    end
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
    let!(:person) { create :it_tech_person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      allow(controller).to receive(:policy).and_return double(update_own_basic?: true)
    end
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
    let!(:person) { create :it_tech_person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      allow(controller).to receive(:policy).and_return double(new_sms_message?: true)
      get :new_sms_message, id: person.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new_sms_message template' do
      expect(response).to render_template(:new_sms_message)
    end
  end

  describe 'POST create_sms_message', vcr: true do
    let(:message) { 'Test message' }
    let!(:person) { create :it_tech_person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      allow(controller).to receive(:policy).and_return double(create_sms_message?: true)
    end
    it 'creates a log entry' do
      expect{
        post :create_sms_message, id: person.id, contact_message: message
      }.to change(LogEntry, :count).by(1)
    end

    it "redirects to the person's page" do
      post :create_sms_message, id: person.id, contact_message: message
      expect(response).to redirect_to(person_path(person))
    end

    it 'creates an SMS message entry' do
      expect {
        post :create_sms_message, id: person.id, contact_message: message
      }.to change(SMSMessage, :count).by(1)
    end
  end
end