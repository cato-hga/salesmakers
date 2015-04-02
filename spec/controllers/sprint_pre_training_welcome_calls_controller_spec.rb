require 'rails_helper'

RSpec.describe SprintPreTrainingWelcomeCallsController, :type => :controller do

  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission, permission_two] }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_two) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }

  describe 'GET new' do
    let(:candidate) { create :candidate }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(new?: true)
    end
    it 'returns a success status' do
      get :new, candidate_id: candidate.id
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let!(:candidate) { create :candidate, training_availability: training_availability }
    let(:training_availability) { create :training_availability }
    before do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    end
    context 'when still available for training, and download at the same time' do
      subject do
        post :create,
             candidate_id: candidate.id,
             sprint_pre_training_welcome_call: {
                 still_able_to_attend: true,
                 group_me_reviewed: true,
                 group_me_confirmed: true,
                 cloud_reviewed: true,
                 cloud_confirmed: true,
                 epay_reviewed: true,
                 epay_confirmed: true,
                 training_availability: {
                     comment: 'Test'
                 }
             }
      end

      it 'creates a welcome call record' do
        expect { subject }.to change(SprintPreTrainingWelcomeCall, :count).by(1)
      end

      it 'assigns the correct attributes' do
        subject
        welcome_call = SprintPreTrainingWelcomeCall.first
        expect(welcome_call.still_able_to_attend).to eq(true)
        expect(welcome_call.group_me_reviewed).to eq(true)
        expect(welcome_call.group_me_confirmed).to eq(true)
        expect(welcome_call.cloud_reviewed).to eq(true)
        expect(welcome_call.cloud_confirmed).to eq(true)
        expect(welcome_call.epay_reviewed).to eq(true)
        expect(welcome_call.epay_confirmed).to eq(true)
        expect(welcome_call.epay_confirmed).to eq(true)
        expect(welcome_call.comment).to eq('Test')
        expect(welcome_call.candidate).to eq(candidate)
      end

      it 'sets the completed status when fully completed' do
        subject
        welcome_call = SprintPreTrainingWelcomeCall.first
        expect(welcome_call.status).to eq('completed')
      end
      it 'redirects to the candidate page' do
        subject
        expect(response).to redirect_to(candidate_path(candidate))
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'does not change the training availability for the candidate' do
        expect { subject }.not_to change(training_availability, :candidate)
      end
    end

    context 'when not available for training' do
      let!(:candidate) { create :candidate, training_availability: training_availability }
      let(:training_availability) { create :training_availability }
      let!(:reason) { create :training_unavailability_reason }
      subject do
        post :create,
             candidate_id: candidate.id,
             sprint_pre_training_welcome_call: {
                 still_able_to_attend: false,
                 group_me_reviewed: false,
                 group_me_confirmed: false,
                 cloud_reviewed: false,
                 cloud_confirmed: false,
                 epay_reviewed: false,
                 epay_confirmed: false,
                 training_availability: {
                     comment: 'Not Attending',
                     training_unavailability_reason_id: reason.id
                 }
             }
      end

      it 'creates a welcome call record' do
        expect { subject }.to change(SprintPreTrainingWelcomeCall, :count).by(1)
      end

      it 'assigns the correct attributes' do
        subject
        welcome_call = SprintPreTrainingWelcomeCall.first
        expect(welcome_call.still_able_to_attend).to eq(false)
        expect(welcome_call.group_me_reviewed).to eq(false)
        expect(welcome_call.group_me_confirmed).to eq(false)
        expect(welcome_call.cloud_reviewed).to eq(false)
        expect(welcome_call.cloud_confirmed).to eq(false)
        expect(welcome_call.epay_reviewed).to eq(false)
        expect(welcome_call.epay_confirmed).to eq(false)
        expect(welcome_call.epay_confirmed).to eq(false)
        expect(welcome_call.comment).to eq('Not Attending')
        expect(welcome_call.candidate).to eq(candidate)
        expect(training_availability.candidate).to eq(candidate)
      end

      it 'sets the completed status when fully completed' do
        subject
        welcome_call = SprintPreTrainingWelcomeCall.first
        expect(welcome_call.status).to eq('completed')
      end
      it 'redirects to the candidate page' do
        subject
        expect(response).to redirect_to(candidate_path(candidate))
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'changes the training availability for the candidate' do
        subject
        candidate.reload
        expect(candidate.training_availability.able_to_attend).to eq(false)
        expect(candidate.training_availability.training_unavailability_reason).to eq(reason)
      end
    end
    context 'when still available for training, but not download at the same time' do
      subject do
        post :create,
             candidate_id: candidate.id,
             sprint_pre_training_welcome_call: {
                 still_able_to_attend: true,
                 group_me_reviewed: true,
                 group_me_confirmed: false,
                 cloud_reviewed: true,
                 cloud_confirmed: false,
                 epay_reviewed: true,
                 epay_confirmed: false,
                 training_availability: {
                     comment: 'Test'
                 }
             }

      end

      it 'creates a welcome call record' do
        expect { subject }.to change(SprintPreTrainingWelcomeCall, :count).by(1)
      end

      it 'assigns the correct attributes' do
        subject
        welcome_call = SprintPreTrainingWelcomeCall.first
        expect(welcome_call.still_able_to_attend).to eq(true)
        expect(welcome_call.group_me_reviewed).to eq(true)
        expect(welcome_call.group_me_confirmed).to eq(false)
        expect(welcome_call.cloud_reviewed).to eq(true)
        expect(welcome_call.cloud_confirmed).to eq(false)
        expect(welcome_call.epay_reviewed).to eq(true)
        expect(welcome_call.epay_confirmed).to eq(false)
        expect(welcome_call.comment).to eq('Test')
        expect(welcome_call.candidate).to eq(candidate)
      end

      it 'sets the started' do
        subject
        welcome_call = SprintPreTrainingWelcomeCall.first
        expect(welcome_call.status).to eq('started')
      end
      it 'redirects to the candidate page' do
        subject
        expect(response).to redirect_to(candidate_path(candidate))
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'does not change the training availability for the candidate' do
        expect { subject }.not_to change(training_availability, :candidate)
      end
    end
  end
end
