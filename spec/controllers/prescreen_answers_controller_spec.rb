require 'rails_helper'

describe PrescreenAnswersController do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:candidate) { create :candidate }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  describe 'GET new' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new,
          candidate_id: candidate.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:new)
    end

    it 'sets the call initiation datetime' do
      expect(assigns(:call_initiated)).not_to be_nil
    end
  end


  describe 'POST create' do
    let!(:call_initiated) { DateTime.now - 5.minutes }
    let(:prescreen_hash) {
      {
          candidate_id: candidate.id,
          prescreen_answer: {
              worked_for_salesmakers: true,
              of_age_to_work: true,
              eligible_smart_phone: true,
              can_work_weekends: true,
              reliable_transportation: true,
              access_to_computer: true,
              part_time_employment: true,
              ok_to_screen: true
          },
          call_initiated: call_initiated.to_i
      }
    }

    subject do
      post :create,
           prescreen_hash.merge(inbound: true)
    end

    it 'creates a Prescreen Answer and attaches it to the correct candidate' do
      expect { subject }.to change(PrescreenAnswer, :count).by(1)
      answer = PrescreenAnswer.first
      expect(answer.candidate).to eq(candidate)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'creates a candidate contact entry' do
      expect { subject }.to change(CandidateContact, :count).by(1)
    end

    it 'sets the candidate contact datetime correctly' do
      subject
      expect(CandidateContact.first.created_at.to_i).to eq(call_initiated.to_i)
    end

    it 'changes the candidate status' do
      subject
      candidate.reload
      expect(candidate.status).to eq('prescreened')
    end

    it 'redirects to the location selection screen' do
      subject
      expect(response).to redirect_to(select_location_candidate_path(candidate, 'false'))
    end

    context 'without an inbound/outbound value' do
      let(:no_inbound) { post :create, prescreen_hash }

      it 'renders the new template' do
        no_inbound
        expect(response).to render_template(:new)
      end
    end

    context 'when a candidate failes the prescreen' do
      before(:each) do
        post :create,
             candidate_id: candidate.id,
             prescreen_answer: {
                 worked_for_salesmakers: true,
                 of_age_to_work: false,
                 eligible_smart_phone: true,
                 can_work_weekends: true,
                 reliable_transportation: true,
                 access_to_computer: true,
                 part_time_employment: true,
                 ok_to_screen: true
             },
             call_initiated: call_initiated.to_i,
             inbound: true
      end

      it 'marks the candidate as inactive' do
        candidate.reload
        expect(candidate.active).to eq(false)
      end
      it 'renders the new template' do
        expect(response).to redirect_to(new_candidate_path)
      end
      it 'sets the candidates status to rejected' do
        candidate.reload
        expect(candidate.status).to eq('rejected')
      end
    end
  end
end