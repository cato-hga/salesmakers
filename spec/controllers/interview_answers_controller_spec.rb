require 'rails_helper'

RSpec.describe InterviewAnswersController, :type => :controller do
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
    context 'success for candidates with job offers' do
      subject do
        post :create,
             candidate_id: candidate.id,
             interview_answer: {
                 work_history: 'Work History',
                 why_in_market: 'Why in market',
                 ideal_position: 'Ideal position',
                 what_are_you_good_at: 'What are you good at',
                 what_are_you_not_good_at: 'What are you not good at',
                 compensation_last_job_one: 'Comp 1',
                 compensation_last_job_two: 'Comp 2',
                 compensation_last_job_three: 'Comp 3',
                 compensation_seeking: 'Seeking comp',
                 hours_looking_to_work: 'Hours looking to work'
             }
      end

      it 'creates a Interview Answer and attaches it to the correct candidate' do
        expect { subject }.to change(InterviewAnswer, :count).by(1)
        answer = InterviewAnswer.first
        expect(answer.candidate).to eq(candidate)
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(2)
      end
      it 'updates the candidate status' do
        subject
        candidate.reload
        expect(candidate.status).to eq('accepted')
      end
      it 'redirects to sending paperwork' do
        subject
        expect(response).to redirect_to(send_paperwork_candidate_path(candidate))
      end
    end
    context 'success for candidates not extended a job offer' do
      subject do
        post :create,
             candidate_id: candidate.id,
             extend_offer: 'false',
             interview_answer: {
                 work_history: 'Work History',
                 why_in_market: 'Why in market',
                 ideal_position: 'Ideal position',
                 what_are_you_good_at: 'What are you good at',
                 what_are_you_not_good_at: 'What are you not good at',
                 compensation_last_job_one: 'Comp 1',
                 compensation_last_job_two: 'Comp 2',
                 compensation_last_job_three: 'Comp 3',
                 compensation_seeking: 'Seeking comp',
                 hours_looking_to_work: 'Hours looking to work'
             }
      end
      it 'creates a Interview Answer and attaches it to the correct candidate' do
        expect { subject }.to change(InterviewAnswer, :count).by(1)
        answer = InterviewAnswer.first
        expect(answer.candidate).to eq(candidate)
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(2)
      end
      it 'updates the candidate status' do
        subject
        candidate.reload
        expect(candidate.status).to eq('rejected')
      end
      it 'redirects to the new candidate screen' do
        subject
        expect(response).to redirect_to(new_candidate_path)
      end
      it 'deactivates the candidate' do
        subject
        candidate.reload
        expect(candidate.active).to eq(false)
      end
    end
  end
end
