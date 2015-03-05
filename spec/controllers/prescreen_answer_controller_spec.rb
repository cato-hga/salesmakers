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
  end

  describe 'POST create' do
    context 'for eligible candidates' do
      subject do
        post :create,
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
             }
      end

      it 'creates a Prescreen Answer and attaches it to the correct candidate' do
        expect { subject }.to change(PrescreenAnswer, :count).by(1)
        answer = PrescreenAnswer.first
        expect(answer.candidate).to eq(candidate)
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'redirects to the location selection screen', pending: 'Not available yet'

    end
  end
end