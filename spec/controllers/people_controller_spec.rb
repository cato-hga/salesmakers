require 'rails_helper'

describe PeopleController do

  describe 'GET index' do
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    it 'returns a success status' do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
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
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
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

  describe 'GET new' do
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new
    end

    it 'returns a success status' do
      expect(response).to be_success
    end
  end

  describe 'GET new_from_candidate' do
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    let!(:candidate) { create :candidate }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new, candidate_id: candidate.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end
  end

  # describe 'PUT update' do
  #   let(:new_phone) { '8135544444' }
  #   let!(:person) { create :it_tech_person }
  #   before(:each) do
  #     CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
  #     allow(controller).to receive(:policy).and_return double(update_own_basic?: true)
  #   end
  #   it 'updates a person' do
  #     put :update,
  #         id: person.id,
  #         person: {
  #             mobile_phone: new_phone
  #         }
  #     expect(response).to be_redirect
  #     # TODO: Need a series of more robust tests as to what is/is not updating
  #   end
  # end

  describe 'GET search' do
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    it 'returns a success status' do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
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
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
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
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
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

  describe 'edit_position' do
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(edit_position?: true)
    end

    subject { get :edit_position, id: person.id }

    it 'returns a success response' do
      expect(response).to be_success
    end
  end

  describe 'update_position' do
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    let!(:new_position) { create :position, name: 'New Position' }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(update_position?: true)
    end

    subject do
      put :update_position,
          id: person.id,
          position_id: new_position.id
    end

    it 'redirects to the person profile page' do
      subject
      expect(response).to redirect_to person_path(person)
    end

    it 'creates a log entry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end

    it 'changes the position' do
      expect {
        subject
        person.reload
      }.to change(person, :position).to new_position
    end
  end

  describe 'commission' do
    let(:area) { create :area }
    let!(:paycheck) {
      create :vonage_paycheck,
             name: '2015-01-01 through 2015-01-15',
             wages_start: Date.new(2015, 1, 1),
             wages_end: Date.new(2015, 1, 15),
             commission_start: Date.new(2015, 1, 2),
             commission_end: Date.new(2015, 1, 14),
             cutoff: Time.now - 23.hours
    }
    let!(:future_paycheck) {
      create :vonage_paycheck,
             name: 'Future Paycheck',
             wages_start: paycheck.wages_start + 3.weeks,
             wages_end: paycheck.wages_end + 3.weeks,
             commission_start: paycheck.commission_start + 3.weeks,
             commission_end: paycheck.commission_end + 3.weeks,
             cutoff: paycheck.cutoff + 3.weeks
    }
    let(:department) { create :department, name: 'Vonage Retail Sales' }
    let(:position) {
      create :position,
             name: 'Vonage Retail Sales Specialist',
             department: department
    }
    let!(:person) { create :person, position: position }
    let!(:person_area) { create :person_area, person: person, area: area }

    before { CASClient::Frameworks::Rails::Filter.fake(person.email) }

    context 'GET commission, without specifying a paycheck' do
      before { get :commission, id: person.id }

      it 'should return a success status' do
        expect(response).to be_success
      end

      it 'should render the commission template' do
        expect(response).to render_template(:commission)
      end

      it 'should render the proper paycheck' do
        expect(assigns(:paycheck)).to eq(paycheck)
      end
    end

    context 'POST commission, specifying a paycheck' do
      before { post :commission, id: person.id, paycheck_id: future_paycheck.id }

      it 'should return a success status' do
        expect(response).to be_success
      end

      it 'should render the commission template' do
        expect(response).to render_template(:commission)
      end

      it 'renders the proper paycheck' do
        expect(assigns(:paycheck)).to eq(future_paycheck)
      end
    end
  end

  describe 'PUT update_changelog_entry_id' do
    let!(:person) { create :person }

    subject do
      put :update_changelog_entry_id,
          id: person.id,
          changelog_entry_id: 2
      person.reload
    end

    it 'returns a success status' do
      subject
      expect(response).to be_success
    end

    it 'changes the changelog_entry_id' do
      expect {
        subject
      }.to change(person, :changelog_entry_id).from(nil).to(2)
    end
  end

  describe 'POST send_asset_form', :vcr do
    let(:message) { 'Test message' }
    let!(:it_tech_person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    let!(:person) { create :person, email: 'aatkinson@salesmakersinc.com' }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(it_tech_person.email)
      allow(controller).to receive(:policy).and_return double(send_asset_form?: true)
      allow(DocusignTemplate).to receive(:send_ad_hoc_template).and_return '123'
    end

    subject do
      post :send_asset_form,
           id: person.id,
           template_guid_and_subject: '61B80AC4-0915-45A2-8C4E-DD809C58F953|Mobile Device Agreement Form for HQ Employee: '
    end

    it 'redirects to People#show' do
      subject
      expect(response).to redirect_to person_path(person)
    end

    it 'creates a log entry' do
      expect {
        subject
      }.to change(LogEntry, :count).by 1
    end
  end

end