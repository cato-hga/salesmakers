require 'rails_helper'

RSpec.describe InterviewAnswersController, :type => :controller do
  let(:recruiter) { create :person }
  let(:candidate) { create :candidate }
  let!(:denial_reason) { create :candidate_denial_reason }

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
    before {
      allow(controller).to receive(:policy).and_return double(create?: true)
    }
    context 'success for candidates with job offers' do
      let(:area) { create :area, personality_assessment_url: 'https://google.com' }
      let(:location_area) { create :location_area, area: area }

      subject do
        post :create,
             candidate_id: candidate.id,
             interview_answer: {
                 work_history: 'Work History',
                 why_in_market: 'Why in market',
                 ideal_position: 'Ideal position',
                 what_are_you_good_at: 'What are you good at',
                 what_are_you_not_good_at: 'What are you not good at',
                 willingness_characteristic: 'Willing',
                 personality_characteristic: 'Willing',
                 self_motivated_characteristic: 'Willing',
                 compensation_last_job_one: 'Comp 1',
                 compensation_last_job_two: 'Comp 2',
                 compensation_last_job_three: 'Comp 3',
                 compensation_seeking: 'Seeking comp',
                 hours_looking_to_work: 'Hours looking to work',
                 last_two_positions: 'Last two positions'
             }
      end

      it 'creates a Interview Answer and attaches it to the correct candidate' do
        expect { subject }.to change(InterviewAnswer, :count).by(1)
        answer = InterviewAnswer.first
        expect(answer.candidate).to eq(candidate)
      end

      it 'assigns the correct attributes' do
        subject
        answer = InterviewAnswer.first
        expect(answer.last_two_positions).to eq('Last two positions')
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(2)
      end
      it 'updates the candidate status' do
        subject
        candidate.reload
        expect(candidate.status).to eq('accepted')
      end

      it 'updates the offer_extended_count of the LocationArea' do
        candidate.update location_area: location_area
        location_area.reload
        expect {
          subject
          location_area.reload
        }.to change(location_area, :offer_extended_count).from(0).to(1)
      end

      it 'redirects to confirmation page' do
        subject
        expect(response).to redirect_to(new_candidate_training_availability_path(candidate))
      end
    end

    context 'for candidates with an old interview' do
      let!(:previous_interview) { create :interview_answer, candidate: candidate }
      let!(:log_entry) { create :log_entry, trackable: previous_interview }
      subject do
        post :create,
             candidate_id: candidate.id,
             interview_answer: {
                 work_history: 'Work History',
                 why_in_market: 'Why in market',
                 ideal_position: 'Ideal position',
                 what_are_you_good_at: 'What are you good at',
                 what_are_you_not_good_at: 'What are you not good at',
                 willingness_characteristic: 'Willing',
                 personality_characteristic: 'Willing',
                 self_motivated_characteristic: 'Willing',
                 compensation_last_job_one: 'Comp 1',
                 compensation_last_job_two: 'Comp 2',
                 compensation_last_job_three: 'Comp 3',
                 compensation_seeking: 'Seeking comp',
                 hours_looking_to_work: 'Hours looking to work',
                 last_two_positions: 'Last two positions'
             }
      end

      it 'if necessary, deletes old interview information' do
        expect(InterviewAnswer.count).to eq(1)
        expect(candidate.interview_answers).to include(previous_interview)
        subject
        expect(InterviewAnswer.count).to eq(1)
        expect(candidate.interview_answers).not_to include(previous_interview)
      end

      it 'if necessary, deletes associated log entries to the interview answer set' do
        expect(LogEntry.count).to eq(1)
        subject
        expect(LogEntry.count).to eq(2)
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
                 willingness_characteristic: 'Willing',
                 personality_characteristic: 'Willing',
                 self_motivated_characteristic: 'Willing',
                 compensation_last_job_one: 'Comp 1',
                 compensation_last_job_two: 'Comp 2',
                 compensation_last_job_three: 'Comp 3',
                 compensation_seeking: 'Seeking comp',
                 hours_looking_to_work: 'Hours looking to work',
                 last_two_positions: 'Last two positions',
                 candidate: {
                     candidate_denial_reason_id: denial_reason.id
                 }
             }

      end
      it 'creates a Interview Answer and attaches it to the correct candidate' do
        expect { subject }.to change(InterviewAnswer, :count).by(1)
        answer = InterviewAnswer.first
        expect(answer.candidate).to eq(candidate)
      end
      it 'assigns the correct attributes' do
        subject
        answer = InterviewAnswer.first
        expect(answer.last_two_positions).to eq('Last two positions')
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
      it 'assigns a candidate denial id' do
        subject
        candidate.reload
        expect(candidate.candidate_denial_reason).to eq(denial_reason)
      end
    end
  end
end
