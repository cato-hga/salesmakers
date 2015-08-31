require 'rails_helper'

describe PrescreenAnswersController do
  include ActiveJob::TestHelper

  let(:recruiter) { create :person }
  let!(:candidate) { create :candidate, location_area: location_area }
  let(:location_area) { create :location_area }

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
    before {
      allow(controller).to receive(:policy).and_return double(create?: true)

    }
    let!(:call_initiated) { DateTime.now - 5.minutes }
    let(:prescreen_hash) {
      {
          candidate_id: candidate.id,
          prescreen_answer: {
              worked_for_radioshack: false,
              worked_for_salesmakers: true,
              of_age_to_work: true,
              high_school_diploma: true,
              can_work_weekends: true,
              reliable_transportation: true,
              eligible_smart_phone: true,
              worked_for_sprint: true,
              ok_to_screen: true,
              visible_tattoos: true,
              has_sales_experience: true,
              sales_experience_notes: 'YesYesYes'
          },
          candidate_availability: {
              monday_first: true
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

    it 'redirects to the interview schedule path' do
      subject
      expect(response).to redirect_to(new_candidate_interview_schedule_path(candidate))
    end

    it 'creates a candidate availability record' do
      subject
      candidate.reload
      expect(candidate.candidate_availability).not_to be_nil
    end

    context 'without an inbound/outbound value' do
      let(:no_inbound) { post :create, prescreen_hash }

      it 'renders the new template' do
        no_inbound
        expect(response).to render_template(:new)
      end
    end

    it 'updates the potential_candidate_count on the LocationArea' do
      expect {
        subject
        location_area.reload
      }.to change(location_area, :potential_candidate_count).from(0).to(1)
    end

    context 'with an existing prescreen...for some reason' do
      let!(:existing_answer) { create :prescreen_answer, candidate: candidate }
      let!(:call_initiated) { DateTime.now - 5.minutes }
      let(:prescreen_hash) {
        {
            candidate_id: candidate.id,
            prescreen_answer: {
                worked_for_radioshack: false,
                worked_for_salesmakers: true,
                of_age_to_work: true,
                high_school_diploma: true,
                can_work_weekends: true,
                reliable_transportation: true,
                eligible_smart_phone: true,
                worked_for_sprint: true,
                ok_to_screen: true,
                visible_tattoos: true,
                has_sales_experience: true,
                sales_experience_notes: 'YesYesYes'

            },
            candidate_availability: {
                monday_first: true
            },
            call_initiated: call_initiated.to_i
        }
      }

      subject do
        post :create,
             prescreen_hash.merge(inbound: true)
      end

      it 'deletes the old prescreen answer before creating' do
        expect(PrescreenAnswer.all.count).to eq(1)
        expect(candidate.prescreen_answers).to include(existing_answer)
        subject
        expect(PrescreenAnswer.all.count).to eq(1)
        expect(candidate.prescreen_answers).not_to include(existing_answer)
      end
    end


    context 'when a candidate fails the prescreen, with availability' do
      before(:each) do
        post :create,
             candidate_id: candidate.id,
             prescreen_answer: {
                 worked_for_radioshack: 'false',
                 worked_for_salesmakers: true,
                 of_age_to_work: true,
                 high_school_diploma: true,
                 can_work_weekends: true,
                 reliable_transportation: true,
                 eligible_smart_phone: true,
                 worked_for_sprint: false,
                 ok_to_screen: true,
                 has_sales_experience: true,
                 sales_experience_notes: 'YesYesYes'
             },
             candidate_availability: {
                 monday_first: true
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
      it 'creates a candidate availability record' do
        subject
        candidate.reload
        expect(candidate.candidate_availability).not_to be_nil
      end
    end

    context 'without availability selected' do
      subject do
        post :create,
             candidate_id: candidate.id,
             prescreen_answer: {
                 worked_for_radioshack: 'false',
                 worked_for_salesmakers: true,
                 of_age_to_work: true,
                 high_school_diploma: true,
                 can_work_weekends: true,
                 reliable_transportation: true,
                 eligible_smart_phone: true,
                 worked_for_sprint: true,
                 ok_to_screen: true,
                 has_sales_experience: true,
                 sales_experience_notes: 'YesYesYes'
             },
             candidate_availability: {
                 monday_first: false
             },
             call_initiated: call_initiated.to_i,
             inbound: true
      end

      it 'renders the new template' do
        subject
        expect(response).to render_template :new
      end

      it 'does not save a Prescreen Answer or Availability' do
        subject
        candidate.reload
        expect(candidate.candidate_availability).to be_nil
        expect(candidate.prescreen_answers.count).to be(0)
      end
    end

    context 'when having worked for radioshack before' do
      subject do
        post :create,
             candidate_id: candidate.id,
             prescreen_answer: {
                 worked_for_radioshack: 'true',
                 former_employment_date_start: '05/25/2005',
                 former_employment_date_end: '05/25/2006',
                 store_number_city_state: '333, St Pete, FL',
                 worked_for_salesmakers: true,
                 of_age_to_work: true,
                 high_school_diploma: true,
                 can_work_weekends: true,
                 reliable_transportation: true,
                 eligible_smart_phone: true,
                 worked_for_sprint: true,
                 ok_to_screen: true,
                 visible_tattoos: true,
                 has_sales_experience: true,
                 sales_experience_notes: 'YesYesYes'
             },
             candidate_availability: {
                 monday_first: true
             },
             call_initiated: call_initiated.to_i,
             inbound: true
      end

      it 'creates a Prescreen Answer and attaches it to the correct candidate' do
        expect { subject }.to change(PrescreenAnswer, :count).by(1)
        answer = PrescreenAnswer.first
        expect(answer.candidate).to eq(candidate)
      end

      it 'creates a candidate contact entry' do
        expect { subject }.to change(CandidateContact, :count).by(1)
      end

      it 'parses the end and start dates' do
        subject
        answer = PrescreenAnswer.first
        expect(answer.former_employment_date_end).to eq('Thu, 25 May 2006'.to_date)
        expect(answer.former_employment_date_start).to eq('Thu, 25 May 2005'.to_date)
      end

      it 'changes the candidate status' do
        subject
        candidate.reload
        expect(candidate.status).to eq('prescreened')
      end

      it 'redirects to the candidate show page' do
        subject
        expect(response).to redirect_to(candidate_path(candidate))
      end

      it 'sends an email to Sprint' do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(CandidateFormerRadioShackMailer).to receive(:vetting_mailer).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        subject
      end
    end
  end

end