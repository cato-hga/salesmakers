require 'rails_helper'

RSpec.describe CandidateSchedulingDismissalsController, :type => :controller do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.create key: 'candidate_index',
                                             description: 'Blah blah blah',
                                             permission_group: permission_group }
  let!(:reason) { create :candidate_denial_reason, name: 'Scheduling Conflict' }
  let!(:candidate) { create :candidate, location_area: location_area }
  let(:location_area) { create :location_area, target_head_count: 2, potential_candidate_count: 1 }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  describe 'GET new' do
    before { get :new, candidate_id: candidate.id }
    it 'returns a success status' do
      expect(response).to be_success
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    before {
      post :create,
           candidate_id: candidate.id,
           candidate_scheduling_dismissal: {
               comment: 'Comment!'
           }

    }

    it 'marks the candidate as inactive' do
      candidate.reload
      expect(candidate.active).to eq(false)
      expect(candidate.status).to eq('rejected')
    end
    it 'deactivates any scheduled interviews' do
      candidate.reload
      schedules = candidate.interview_schedules.where(active: true)
      expect(schedules.count).to eq(0)
    end
    it 'renders the index page' do
      expect(response).to redirect_to(candidates_path)
    end
    it 'creates a log entry' do
      expect(LogEntry.count).to eq(1)
    end
    it 'creates a CandidateSchedulingDismissal' do
      expect(CandidateSchedulingDismissal.count).to eq(1)
    end
    it 'assigns a denial reason' do
      candidate.reload
      expect(candidate.candidate_denial_reason).to eq(reason)
    end
  end
end