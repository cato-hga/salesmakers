require 'rails_helper'

describe CandidatesController do
  include ActiveJob::TestHelper
  let(:recruiter) { create :person, position: position }
  let(:position) {
    create :position,
           name: 'Advocate',
           permissions: [
               permission_create,
               permission_index,
               permission_view_all
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
  let(:permission_view_all) { Permission.new key: 'candidate_view_all',
                                             permission_group: permission_group,
                                             description: 'Test Description' }
  let(:location_area) { create :location_area, location: location }
  let!(:sprint_radio_shack_training_session) {
    create :sprint_radio_shack_training_session
  }
  let(:location) { create :location }
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

  describe 'GET support_search' do
    before { get :support_search }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:support_search)
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
    context 'success, going to select_location' do
      subject {
        post :create,
             candidate: {
                 first_name: 'Test',
                 last_name: 'Candidate',
                 mobile_phone: '7274985180',
                 email: 'test@test.com',
                 zip: '33701',
                 candidate_source_id: source.id
             },
             select_location: 'true'
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
      it 'redirects to select location' do
        subject
        candidate = Candidate.first
        expect(response).to redirect_to(select_location_candidate_path(candidate, 'false'))
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

    context 'success, left voicemail' do
      let!(:call_initiated) { DateTime.now - 5.minutes }
      subject {
        post :create,
             candidate: {
                 first_name: 'Test',
                 last_name: 'Candidate',
                 mobile_phone: '7274985180',
                 email: 'test@test.com',
                 zip: '33701',
                 location_area_id: position.id,
                 candidate_source_id: source.id
             },
             start_prescreen: 'false',
             call_initiated: call_initiated.to_i
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
      it 'redirects to candidates#index' do
        subject
        expect(response).to redirect_to(candidates_path)
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
      it 'creates a candidate contact' do
        expect { subject }.to change(CandidateContact, :count).by(1)
      end
      it 'sets the candidate contact datetime correctly' do
        subject
        expect(CandidateContact.first.created_at.to_i).to eq(call_initiated.to_i)
      end
    end

    context 'success, outsourced' do
      let!(:outsourced) { create :candidate_source, name: 'Outsourced' }
      subject {
        post :create,
             candidate: {
                 first_name: 'Test',
                 last_name: 'Candidate',
                 mobile_phone: '7274985180',
                 email: 'test@test.com',
                 zip: '33701',
                 candidate_source_id: outsourced.id
             },
             start_prescreen: 'true'
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
      it 'redirects to select location' do
        subject
        candidate = Candidate.first
        expect(response).to redirect_to(select_location_candidate_path(candidate, 'false'))
      end
      it 'saves the candidates recruiter/person' do
        subject
        candidate = Candidate.first
        expect(candidate.created_by).to eq(recruiter)
      end
      it 'saves the candidates source' do
        subject
        candidate = Candidate.first
        expect(candidate.candidate_source).to eq(outsourced)
      end
    end

    context 'failure' do
      subject {
        post :create,
             candidate: {
                 first_name: 'Test',
                 last_name: 'Candidate',
                 mobile_phone: '',
                 zip: '33701'
             }
      }
      it 'renders the new template' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET edit' do
    let(:candidate) { create :candidate }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(edit?: true)
    end
    it 'returns a success status' do
      get :edit, id: candidate.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH update' do
    let(:candidate) { create :candidate }
    context 'success' do
      subject do
        patch :update,
              id: candidate.id,
              candidate: {
                  first_name: 'Anewfirstname'
              }

      end
      it 'updates the candidate' do
        subject
        candidate.reload
        expect(candidate.first_name).to eq('Anewfirstname')
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

      it 'redirects to candidate#show' do
        subject
        expect(response).to redirect_to candidate_path candidate
      end
    end

    context 'failure' do
      subject do
        patch :update,
              id: candidate.id,
              candidate: {
                  first_name: ''
              }

      end
      it 'renders new' do
        subject
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET select_location' do
    let(:candidate) { create :candidate }

    before { get :select_location, id: candidate.id, back_to_confirm: 'false' }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the select_location template' do
      expect(response).to render_template(:select_location)
    end
  end

  describe 'GET set_location_area' do
    let!(:candidate) { create :candidate, status: :entered }
    let(:location) { create :location }
    let(:area) { create :area }
    let!(:location_area) { create :location_area, location: location, area: area }
    let!(:second_location_area) { create :location_area, area: area, offer_extended_count: 1 }

    context 'for non-outsourced locations' do
      let!(:location_area) { create :location_area, location: location, area: area, outsourced: false }
      subject {
        get :set_location_area,
            id: candidate.id,
            location_area_id: location_area.id,
            back_to_confirm: 'false'
      }

      it 'redirects to prescreen' do
        subject
        expect(response).to redirect_to(new_candidate_prescreen_answer_path(candidate))
      end

      it 'sets the location_area_id on the candidate' do
        expect {
          subject
          candidate.reload
        }.to change(candidate, :location_area_id).from(nil).to(location_area.id)
      end

      it 'updates the potential_candidate_count on the LocationArea if the candidate is prescreened' do
        expect {
          candidate.update status: :prescreened
          candidate.reload
          subject
          location_area.reload
        }.to change(location_area, :potential_candidate_count).from(0).to(1)
      end

      it 'updates the offer_extended_count on the LocationArea if necessary' do
        expect {
          candidate.update location_area: second_location_area,
                           status: :accepted
          subject
          second_location_area.reload
        }.to change(second_location_area, :offer_extended_count).from(1).to(0)
      end

      it 'does not update the offer_extended_count on the LocationArea if unnecessary' do
        expect {
          candidate.update location_area: second_location_area,
                           status: :prescreened
          subject
          second_location_area.reload
        }.not_to change(second_location_area, :offer_extended_count)
      end

      it 'updates the candidate status' do
        subject
        candidate.reload
        expect(candidate.status).to eq('location_selected')
      end

      it 'sends the candidate the personality assessment URL' do
        expect {
          subject
          perform_enqueued_jobs do
            ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
          end
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
    end

    context 'for outsourced locations' do
      let!(:location_area) { create :location_area, location: location, area: area, outsourced: true }
      subject {
        get :set_location_area,
            id: candidate.id,
            location_area_id: location_area.id,
            back_to_confirm: 'false'
      }

      it 'redirects to training availability' do
        subject
        expect(response).to redirect_to(new_candidate_training_availability_path(candidate))
      end

      it 'sets the location_area_id on the candidate' do
        expect {
          subject
          candidate.reload
        }.to change(candidate, :location_area_id).from(nil).to(location_area.id)
      end

      it 'updates the potential_candidate_count on the LocationArea' do
        allow(candidate).to receive(:prescreened?).and_return(true)
        expect {
          subject
          location_area.reload
        }.to change(location_area, :potential_candidate_count).from(0).to(1)
      end

      it 'updates the offer_extended_count on the LocationArea if necessary' do
        expect {
          candidate.update location_area: second_location_area,
                           status: :accepted
          subject
          second_location_area.reload
        }.to change(second_location_area, :offer_extended_count).from(1).to(0)
      end

      it 'does not update the offer_extended_count on the LocationArea if unnecessary' do
        expect {
          candidate.update location_area: second_location_area,
                           status: :prescreened
          subject
          second_location_area.reload
        }.not_to change(second_location_area, :offer_extended_count)
      end

      it 'does not send the candidate the personality assessment URL' do
        expect {
          subject
          perform_enqueued_jobs do
            ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
          end
        }.to raise_error(NoMethodError)
      end

      it 'does not creates a log entry' do
        expect { subject }.not_to change(LogEntry, :count)
      end

      it 'skips to the confirmation page' do
        subject
        expect(response).to redirect_to(new_candidate_training_availability_path(candidate))
      end

      it 'updates the candidate status' do
        subject
        candidate.reload
        expect(candidate.status).to eq('accepted')
      end

      it 'updates the offer_extended_count of the LocationArea' do
        expect {
          subject
          location_area.reload
        }.to change(location_area, :offer_extended_count).from(0).to(1)
      end
    end
  end


  describe 'GET send_paperwork' do
    let(:candidate) { create :candidate, state: 'FL', location_area: location_area }
    let(:location_area) { create :location_area }
    let!(:docusign_template) {
      create :docusign_template,
             template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5',
             state: 'FL',
             project: location_area.area.project,
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
    subject do
      get :new_sms_message, id: candidate.id
    end

    it 'returns a success status' do
      subject
      expect(response).to be_success
    end

    it 'renders the new_sms_message template' do
      subject
      expect(response).to render_template(:new_sms_message)
    end

    it 'errors when the phone is not 10 digits in length' do
      candidate.mobile_phone = '800555121'
      candidate.save validate: false
      request.env['HTTP_REFERER'] = 'https://google.com'
      subject
      expect(response).to redirect_to(:back)
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

    it 'creates a Candidate Contact entry' do
      expect {
        subject
      }.to change(CandidateContact, :count).by(1)
    end
  end

  describe 'PATCH reactivate' do
    context 'success' do
      let!(:candidate) { create :candidate, active: false, location_area: location_area }
      subject do
        get :reactivate,
            id: candidate.id
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'redirects to candidate#show' do
        subject
        expect(response).to redirect_to(candidate_path(candidate))
      end
      it 'reactivates the candidate' do
        subject
        candidate.reload
        expect(candidate.active).to eq(true)
      end
      it 'decreases the potential candidate count' do
        expect(location_area.potential_candidate_count).to eq(0)
        subject
        candidate.reload
        location_area.reload
        expect(location_area.potential_candidate_count).to eq(1)
      end
    end

    context 'success (status changes)' do
      let!(:candidate) { create :candidate, active: false }
      let(:offer) { create :job_offer_detail }
      let(:interview) { create :interview_answer }
      let(:schedule) { create :interview_schedule }
      let(:answers) { create :prescreen_answer }
      subject do
        get :reactivate,
            id: candidate.id
      end
      it 'resets the candidate to a paperwork sent status if applicable' do
        candidate.job_offer_details << offer
        subject
        candidate.reload
        expect(candidate.status).to eq('paperwork_sent')
      end

      it 'resets the candidate to an interviewed status if applicable' do
        candidate.interview_answers << interview
        subject
        candidate.reload
        expect(candidate.status).to eq('interviewed')
      end
      it 'resets the candidate to a scheduled status if applicable' do
        candidate.interview_schedules << schedule
        subject
        candidate.reload
        expect(candidate.status).to eq('interview_scheduled')
      end
      it 'resets the candidate to a location selected status if applicable' do
        candidate.location_area = location_area
        candidate.save
        subject
        candidate.reload
        expect(candidate.status).to eq('location_selected')
      end
      it 'resets the candidate to a prescreened status if applicable' do
        candidate.prescreen_answers << answers
        subject
        candidate.reload
        expect(candidate.status).to eq('prescreened')
      end
      it 'resets the candidate to a entered status if applicable' do
        subject
        candidate.reload
        expect(candidate.status).to eq('entered')
      end
    end
  end

  describe 'GET dismiss' do
    let(:candidate) { create :candidate }
    before(:each) do
      get :dismiss,
          id: candidate.id
    end
    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the dismissal template' do
      expect(response).to render_template(:dismiss)
    end
  end

  describe 'DELETE destroy' do
    let(:candidate) { create :candidate }
    let!(:interview) { create :interview_schedule, person: recruiter, candidate: candidate }
    let!(:reason) { create :candidate_denial_reason }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(destroy?: true)
      delete :destroy,
             id: candidate.id,
             candidate: {
                 candidate_denial_reason_id: reason.id
             }
    end

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
  end

  describe 'PUT record_assessment_score' do
    let(:candidate) { create :candidate, status: :accepted }
    let!(:interview_schedule_one) { create :interview_schedule, candidate: candidate }
    let!(:interview_schedule_two) { create :interview_schedule, candidate: candidate }

    let!(:failed_denial_reason) {
      create :candidate_denial_reason,
             name: "Personality assessment score does not qualify for employment",
             active: true
    }

    before { allow(controller).to receive(:policy).and_return double(record_assessment_score?: true) }

    context 'failing score' do
      subject do
        put :record_assessment_score,
            id: candidate.id,
            assessment_score: 30
        candidate.reload
      end

      it 'creates a log entry' do
        expect {
          subject
        }.to change(LogEntry, :count).by(4) #Creating log entries for interview cancelling
      end

      it "sets the candidate's denial reason" do
        subject
        expect(candidate.candidate_denial_reason).to eq(failed_denial_reason)
      end

      it 'marks the candidate as having completed their assessment' do
        subject
        expect(candidate.personality_assessment_completed?).to be_truthy
      end

      it 'sets the personality assessment score' do
        subject
        expect(candidate.personality_assessment_score).to eq(30)
      end

      it 'marks the candidate as inactive' do
        subject
        expect(candidate.active?).to be_falsey
      end

      it 'sets the candidate status to rejected' do
        subject
        expect(candidate.rejected?).to be_truthy
      end

      it 'sets the personality_assessment_status to disqualified' do
        expect {
          subject
        }.to change(candidate, :personality_assessment_status).to('disqualified')
      end

      it 'sends an email to the candidate' do
        expect {
          subject
          perform_enqueued_jobs do
            ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
          end
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'cancels any scheduled interviews' do
        expect {
          subject
          interview_schedule_one.reload
        }.to change(interview_schedule_one, :active).to false
        expect {
          subject
          interview_schedule_two.reload
        }.to change(interview_schedule_two, :active).to false
      end
    end

    context 'passing score' do
      subject do
        put :record_assessment_score,
            id: candidate.id,
            assessment_score: 32
        candidate.reload
      end

      it 'creates a log entry' do
        expect {
          subject
        }.to change(LogEntry, :count).by(1)
      end

      it 'marks the candidate as having completed their assessment' do
        subject
        expect(candidate.personality_assessment_completed?).to be_truthy
      end

      it 'sets the personality assessment score' do
        subject
        expect(candidate.personality_assessment_score).to eq(32)
      end

      it 'keeps the candidate active' do
        subject
        expect(candidate.active?).to be_truthy
      end

      it 'does not change the candidate status' do
        expect {
          subject
        }.not_to change(candidate, :status)
      end

      it 'sets the personality_assessment_status to qualified' do
        expect {
          subject
        }.to change(candidate, :personality_assessment_status).to('qualified')
      end
    end
  end

  describe 'GET dashboard' do
    before do
      get :dashboard
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the dashboard template' do
      expect(response).to render_template(:dashboard)
    end
  end

  describe 'GET edit_availability' do
    let(:candidate) { create :candidate }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(edit_availability?: true)
    end
    it 'returns a success status' do
      get :edit_availability, id: candidate.id
      expect(response).to be_success
      expect(response).to render_template(:edit_availability)
    end
  end

  describe 'PATCH update_availability' do
    let(:candidate) { create :candidate, candidate_availability: available }
    let(:available) { create :candidate_availability, sunday_first: true }
    before(:each) do
      patch :update_availability,
            id: candidate.id,
            candidate_availability: {
                monday_first: true,
                monday_second: false,
                monday_third: true
            }
      candidate.reload
    end

    it 'updates the candidates availability' do
      expect(candidate.candidate_availability.monday_first).to eq(true)
      expect(candidate.candidate_availability.monday_first).to eq(true)
      expect(candidate.candidate_availability.monday_third).to eq(true)
      expect(candidate.candidate_availability.monday_second).to eq(false)
    end

    it 'renders the candidate show page' do
      expect(response).to redirect_to candidate_path candidate
    end

    it 'creates a log entry' do
      expect(LogEntry.count).to be(1)
    end
  end

  describe 'GET resend_assessment' do
    let(:candidate) { create :candidate, state: 'FL', location_area: location_area }
    let(:location_area) { create :location_area }

    before { allow(controller).to receive(:policy).and_return double(resend_assessment?: true) }

    it 'sends the assessment' do
      get :resend_assessment,
          id: candidate.id
      expect(response).to redirect_to(candidate_path(candidate))
    end
  end

  describe 'POST cant_make_training_location' do
    let(:candidate) { create :candidate }
    let!(:cant_make_location) { create :training_unavailability_reason, name: "Can't Make Training Location" }
    subject do
      allow(controller).to receive(:policy).and_return double(cant_make_training_location?: true)
      post :cant_make_training_location,
           id: candidate.id
    end
    it 'redirects to candidate#show' do
      subject
      expect(response).to redirect_to(candidate_path(candidate))
    end
    it 'creates a training unavailability' do
      expect { subject }.to change(TrainingAvailability, :count).by(1)
    end
    it 'assigns the proper availability' do
      subject
      candidate.reload
      expect(candidate.training_availability.able_to_attend).to eq(false)
      expect(candidate.training_availability.training_unavailability_reason).to eq(cant_make_location)
    end
  end

  describe 'PUT set_sprint_radio_shack_training_session' do
    let!(:candidate) { create :candidate }

    subject do
      put :set_sprint_radio_shack_training_session,
          id: candidate.id,
          sprint_radio_shack_training_session: {
              id: sprint_radio_shack_training_session.id
          }
    end

    it 'should be a redirect to the candidate show page' do
      subject
      expect(response).to redirect_to(candidate_path(candidate))
    end

    it 'saves the SprintRadioShackTrainingSession' do
      expect {
        subject
        candidate.reload
      }.to change(candidate, :sprint_radio_shack_training_session_id).
               from(nil).to(sprint_radio_shack_training_session.id)
    end
  end
end
