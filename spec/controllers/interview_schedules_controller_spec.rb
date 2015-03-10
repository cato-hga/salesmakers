require 'rails_helper'

describe InterviewSchedulesController do
  include ActiveJob::TestHelper
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  let(:candidate) { create :candidate }
  let(:interview_schedule) { build :interview_schedule }

  describe 'GET new' do
    before(:each) do
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
  end

  describe 'GET interview_now' do
    context 'success' do
      before(:each) do
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
    end
  end

  describe 'GET schedule' do
    before(:each) do
      expect(controller).to receive(:create)
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
      post :time_slots,
           candidate_id: candidate.id,
           interview_date: Date.today
    end
    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the time_slot template' do
      expect(response).to render_template(:time_slots)
    end
  end
end