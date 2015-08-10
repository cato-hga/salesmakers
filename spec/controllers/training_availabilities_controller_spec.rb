require 'rails_helper'

RSpec.describe TrainingAvailabilitiesController, :type => :controller do

  let!(:recruiter) { create :person }
  let!(:candidate) { create :candidate, location_area: location_area, state: 'FL' }
  let!(:location_area) { create :location_area }
  let!(:reason) { create :training_unavailability_reason }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  describe 'GET new' do
    before {
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new, candidate_id: candidate.id
    }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the confirm template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    before {
      allow(controller).to receive(:policy).and_return double(create?: true)

    }
    context 'when available to train' do
      subject do
        post :create,
             candidate_id: candidate.id,
             training_availability: {
                 candidate: {
                     shirt_gender: 'Male',
                     shirt_size: 'L'
                 },
                 able_to_attend: 'true'
             }
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

      it 'updates the candidate status' do
        subject
        candidate.reload
        expect(candidate.status).to eq('confirmed')
      end

      it 'updates the candidates shirt information' do
        subject
        candidate.reload
        expect(candidate.shirt_size).to eq('L')
        expect(candidate.shirt_gender).to eq('Male')
      end

      context 'when personality assessment passed' do
        before do
          candidate.update personality_assessment_completed: true,
                           location_area: location_area
        end

        it 'redirects to sending paperwork' do
          subject
          expect(response).to redirect_to(send_paperwork_candidate_path(candidate))
        end
      end

      context 'when personality assessment not passed' do
        before do
          candidate.update personality_assessment_completed: true,
                           location_area: location_area,
                           active: false
        end

        it 'redirects to candidate page' do
          subject
          expect(response).to redirect_to(candidate_path(candidate))
        end
      end
    end

    context 'when not available to train' do
      subject do
        post :create,
             candidate_id: candidate.id,
             training_availability: {
                 candidate: {
                     shirt_gender: 'Male',
                     shirt_size: 'L'
                 },
                 able_to_attend: 'false',
                 training_unavailability_reason_id: reason.id,
                 comments: 'Test'
             }
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

      it 'updates the candidate status' do
        subject
        candidate.reload
        expect(candidate.status).to eq('confirmed')
      end

      it 'updates the candidates shirt information' do
        subject
        candidate.reload
        expect(candidate.shirt_size).to eq('L')
        expect(candidate.shirt_gender).to eq('Male')
      end
      it 'creates training availability record' do
        subject
        candidate.reload
        expect(candidate.training_availability.able_to_attend).to eq(false)
        expect(candidate.training_availability.training_unavailability_reason).to eq(reason)
        expect(candidate.training_availability.comments).to eq('Test')
      end
    end

    context 'when confirming a prior candidate (paperwork already sent)' do
      let!(:candidate_with_paper) { create :candidate, location_area: location_area_two, state: 'FL' }
      let!(:job_offer_detail) { create :job_offer_detail, candidate: candidate_with_paper }
      let!(:location_area_two) { create :location_area }

      subject do
        post :create,
             candidate_id: candidate_with_paper.id,
             training_availability: {
                 candidate: {
                     shirt_gender: 'Male',
                     shirt_size: 'L'
                 },
                 able_to_attend: 'true'
             }
      end

      it 'saves the training availability' do
        expect(candidate_with_paper.training_availability).to be_nil
        subject
        candidate_with_paper.reload
        expect(candidate_with_paper.training_availability).not_to be_nil
      end

      it 'does not send paperwork' do
        expect(candidate_with_paper.job_offer_details).to eq([job_offer_detail])
        subject
        candidate_with_paper.reload
        expect(candidate_with_paper.job_offer_details).to eq([job_offer_detail])
      end

      it 'redirects to the candidate show page' do
        subject
        expect(response).to redirect_to candidate_path candidate_with_paper
      end
    end
  end

  describe 'GET edit' do
    let!(:available) { create :training_availability, candidate: candidate }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(edit?: true)
    end
    it 'returns a success status' do
      get :edit,
          id: available.id,
          candidate_id: candidate.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH update' do
    let!(:candidate) { create :candidate,
                              shirt_size: 'M',
                              shirt_gender: 'Female',
                              training_availability: available,
                              location_area: location_area

    }
    let!(:reason) { create :training_unavailability_reason }
    let(:available) { create :training_availability, able_to_attend: false, training_unavailability_reason: reason }
    subject do
      allow(controller).to receive(:policy).and_return double(update?: true)
      patch :update,
            id: available.id,
            candidate_id: candidate.id,
            training_availability: {
                able_to_attend: 'true',
                candidate: {
                    shirt_size: 'L',
                    shirt_gender: 'Male'
                }
            }
      candidate.reload
    end
    it 'updates the candidates details' do
      expect(candidate.shirt_size).to eq('M')
      expect(candidate.shirt_gender).to eq('Female')
      expect(candidate.training_availability.able_to_attend).to eq(false)
      subject
      expect(candidate.shirt_size).to eq('L')
      expect(candidate.shirt_gender).to eq('Male')
      expect(candidate.training_availability.able_to_attend).to eq(true)
    end
    it 'redirects to candidate#show' do
      subject
      expect(response).to redirect_to(candidate_path(candidate))
    end
    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
  end
end
