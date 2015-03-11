require 'rails_helper'

describe CandidatesController do
  let(:recruiter) { create :person, position: position }
  let(:position) {
    create :position,
           name: 'Advocate',
           permissions: [
               permission_create,
               permission_index
           ],
           hq: true,
           all_field_visibility: true
  }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let(:location) { create :location }
  let(:project) { create :project, name: 'Comcast Retail' }
  let(:source) { create :candidate_source }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  describe 'GET index' do
    before { get :index }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(new?: true)
    end
    it 'returns a success status' do
      get :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(create?: true)
    end
    context 'success' do
      subject {
        post :create,
             candidate: {
                 first_name: 'Test',
                 last_name: 'Candidate',
                 mobile_phone: '7274985180',
                 email: 'test@test.com',
                 zip: '33701',
                 project_id: position.id,
                 candidate_source_id: source.id
             }
      }
      it 'creates a candidate' do
        expect { subject }.to change(Candidate, :count).by(1)
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'sets the candidate as entered' do
        subject
        expect(Candidate.first.entered?).to be_truthy
      end
      it 'redirects to prescreen_questions#new' do
        subject
        candidate = Candidate.first
        expect(response).to redirect_to(new_candidate_prescreen_answer_path(candidate))
      end
      it 'saves the candidates recruiter/person' do
        subject
        candidate = Candidate.first
        expect(candidate.created_by).to eq(recruiter)
      end
      it 'saves the candidates source' do
        subject
        candidate = Candidate.first
        expect(candidate.candidate_source).to eq(source)
      end
    end

    context 'failure' do
      subject {
        post :create,
             candidate: {
                 first_name: 'Test',
                 last_name: 'Candidate',
                 mobile_phone: '',
                 zip: '33701',
                 project_id: 1
             }
      }
      it 'renders the new template' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET select_location' do
    let(:candidate) { create :candidate }

    before { get :select_location, id: candidate.id, send_nhp: 'false' }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the select_location template' do
      expect(response).to render_template(:select_location)
    end
  end

  describe 'GET set_location_area' do
    let!(:candidate) { create :candidate }
    let(:location) { create :location }
    let(:area) { create :area, project: candidate.project }
    let!(:location_area) { create :location_area, location: location, area: area }

    subject {
      get :set_location_area,
          id: candidate.id,
          location_area_id: location_area.id,
          send_nhp: 'false'
    }

    it 'redirects to interview schedule' do
      subject
      expect(response).to redirect_to(new_candidate_interview_schedule_path(candidate))
    end

    it 'sets the location_area_id on the candidate' do
      expect {
        subject
        candidate.reload
      }.to change(candidate, :location_area_id).from(nil).to(location_area.id)
    end

    it 'updates the potential_candidate_count on the LocationArea' do
      expect {
        subject
        location_area.reload
      }.to change(location_area, :potential_candidate_count).from(0).to(1)
    end

    it 'updates the candidate status' do
      subject
      candidate.reload
      expect(candidate.status).to eq('location_selected')
    end
  end

  describe 'GET confirm_location' do
    let!(:candidate) { create :candidate, location_area: location_area }
    let!(:location_area) { create :location_area }

    before { get :confirm_location, id: candidate.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'sets the location_area_id on the candidate' do
      expect(response).to render_template(:confirm_location)
    end
  end

  describe 'GET send_paperwork' do
    let(:candidate) { create :candidate, state: 'FL' }
    let!(:docusign_template) {
      create :docusign_template,
             template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5',
             state: 'FL',
             project: candidate.project,
             document_type: 0
    }

    before { get :send_paperwork, id: candidate.id }

    it 'redirects to the candidate show page', :vcr do
      expect(response).to redirect_to(candidate_path(candidate))
    end

    it 'changes the candidate status', :vcr do
      candidate.reload
      expect(candidate.status).to eq('paperwork_sent')
    end
  end

  describe 'GET new_sms_message' do
    let(:candidate) { create :candidate }
    before(:each) do
      get :new_sms_message, id: candidate.id
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
    let!(:candidate) { create :candidate }

    subject { post :create_sms_message, id: candidate.id, contact_message: message }

    it 'creates a log entry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end

    it "redirects to the candidate's page" do
      subject
      expect(response).to redirect_to(candidate_path(candidate))
    end

    it 'creates an SMS message entry' do
      expect {
        subject
      }.to change(SMSMessage, :count).by(1)
    end
  end
end