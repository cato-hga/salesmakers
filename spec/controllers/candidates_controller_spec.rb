require 'rails_helper'

describe CandidatesController do
  let(:recruiter) { create :person, position: position }
  let(:position) {
    create :position,
           name: 'Advocate',
           permissions: [
               permission_create,
               permission_index
           ]
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
                 project_id: position.id
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

    before { get :select_location, id: candidate.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the select_location template' do
      expect(response).to render_template(:select_location)
    end
  end

  describe 'GET set_location' do
    let!(:candidate) { create :candidate }
    let(:location) { create :location }
    let(:area) { create :area, project: candidate.project }
    let!(:location_area) { create :location_area, location: location, area: area }

    subject {
      get :set_location,
          id: candidate.id,
          location_id: location.id
    }

    it 'redirects to interview schedule' do
      subject
      expect(response).to redirect_to(new_candidate_interview_schedule_path(candidate))
    end

    it 'sets the location_id on the candidate' do
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
end