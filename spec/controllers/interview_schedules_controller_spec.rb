require 'rails_helper'

describe InterviewSchedulesController do
  include ActiveJob::TestHelper
  let!(:recruiter) { create :person }
  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  let!(:candidate) { create :candidate }
  let!(:interview_schedule) { build :interview_schedule }

  describe 'GET index' do
    before {
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index, schedule_date: Date.today.to_s
    }

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
      get :new,
          candidate_id: candidate.id
    end
    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    context 'success' do
      before(:each) do
        allow(controller).to receive(:policy).and_return double(create?: true)
        post :create,
             interview_date: Date.today.strftime('%Y%m%d'),
             interview_time: Time.zone.now.strftime('%H%M'),
             candidate_id: candidate.id,
             person_id: recruiter.id,
             cloud_room: '33711'
      end

      it 'schedules the candidate' do
        expect(InterviewSchedule.all.count).to eq(1)
      end

      it 'creates a log entry' do
        expect(LogEntry.all.count).to eq(1)
      end

      it 'redirects to the candidate show path' do
        expect(response).to redirect_to(candidate_path(candidate))
      end

      it 'changes the candidate status' do
        candidate.reload
        expect(candidate.status).to eq('interview_scheduled')
      end

      it 'sends emails to the recruiter and candidate' do
        candidate.reload
        expect { perform_enqueued_jobs do
          ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
        end
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context 'reschedule success' do
      let!(:scheduled_candidate) { create :candidate, interview_schedules: [interview], status: 'interview_scheduled' }
      let(:interview) { create :interview_schedule, active: true }
      before(:each) do
        @time_now = Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)
        allow(Time).to receive(:now).and_return(@time_now)
        allow(controller).to receive(:policy).and_return double(create?: true)
        post :create,
             interview_date: Date.tomorrow.strftime('%Y%m%d'),
             interview_time: Time.zone.now.strftime('%H%M'),
             candidate_id: scheduled_candidate.id,
             person_id: recruiter.id,
             cloud_room: '33711'
      end

      it 'schedules the candidate' do
        new_interview = InterviewSchedule.find_by interview_date: Date.tomorrow.strftime('%Y%m%d')
        scheduled_candidate.reload
        active_interviews = scheduled_candidate.interview_schedules.where(active: true)
        expect(active_interviews).to include(new_interview)
        expect(active_interviews).not_to include(interview)
      end

      it 'creates a log entry' do
        expect(LogEntry.all.count).to eq(2)
      end

      it 'redirects to the candidate show path' do
        expect(response).to redirect_to(candidate_path(scheduled_candidate))
      end

      it 'keeps the candidate status' do
        scheduled_candidate.reload
        expect(scheduled_candidate.status).to eq('interview_scheduled')
      end

      it 'sends emails to the recruiter and candidate' do
        scheduled_candidate.reload
        expect { perform_enqueued_jobs do
          ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
        end
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'deactivates other scheduled interviews' do
        scheduled_candidate.reload
        active_interviews = scheduled_candidate.interview_schedules.where(active: true)
        expect(active_interviews.count).to eq(1)
      end
    end

    context 'failure' do
      before(:each) do
        expect(InterviewSchedule).to receive(:new).and_return(interview_schedule)
        expect(interview_schedule).to receive(:save).and_return false
        allow(controller).to receive(:policy).and_return double(create?: true)
        post :create,
             interview_date: Date.today.strftime('%Y%m%d'),
             interview_time: Time.zone.now.strftime('%H%M'),
             candidate_id: candidate.id,
             person_id: recruiter.id,
             cloud_room: '33711'
      end

      it 'does not schedule the candidate' do
        expect(InterviewSchedule.all.count).to eq(0)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET interview_now' do
    context 'success' do
      before(:each) do
        allow(controller).to receive(:policy).and_return double(interview_now?: true)
        get :interview_now,
            candidate_id: candidate.id
      end
      it 'schedules the candidate' do
        expect(InterviewSchedule.all.count).to eq(1)
      end
      it 'creates a log entry' do
        expect(LogEntry.all.count).to eq(1)
      end

      it 'redirects to the cinterview answer path' do
        expect(response).to redirect_to(new_candidate_interview_answer_path(candidate))
      end

      it 'changes the candidate status' do
        candidate.reload
        expect(candidate.status).to eq('interview_scheduled')
      end
      it 'sends emails to the recruiter and candidate' do
        candidate.reload
        expect { perform_enqueued_jobs do
          ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
        end
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
    context 'failure' do
      before(:each) do
        expect(InterviewSchedule).to receive(:new).and_return(interview_schedule)
        expect(interview_schedule).to receive(:save).and_return false
        allow(controller).to receive(:policy).and_return double(interview_now?: true)
        get :interview_now,
            candidate_id: candidate.id
      end

      it 'does not schedule the candidate' do
        expect(InterviewSchedule.all.count).to eq(0)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET schedule' do
    before(:each) do
      expect(controller).to receive(:create)
      allow(controller).to receive(:policy).and_return double(schedule?: true)
      get :schedule,
          candidate_id: candidate.id,
          interview_date: Date.today.strftime('%Y%m%d'),
          interview_time: Time.zone.now.strftime('%H%M')
    end
    it 'returns a success status' do
      expect(response).to be_success
    end
  end

  describe 'POST time_slots' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(time_slots?: true)
      post :time_slots,
           candidate_id: candidate.id,
           interview_date: Date.today,
           cloud_room: '11111'
    end
    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the time_slot template' do
      expect(response).to render_template(:time_slots)
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      interview_schedule.save
      allow(controller).to receive(:policy).and_return double(destroy?: true)
      delete :destroy,
             id: interview_schedule.id,
             candidate_id: candidate.id
    end

    it 'marks the interview as inactive' do
      interview_schedule.reload
      expect(interview_schedule.active).to eq(false)
    end
    it 'renders the schedules page' do
      expect(response).to redirect_to(interview_schedules_path(interview_schedule.interview_date))
    end
    it 'creates a log entry' do
      expect(LogEntry.count).to eq(1)
    end
  end
end