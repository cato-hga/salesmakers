require 'rails_helper'

RSpec.describe CandidateAvailabilitiesController, :type => :controller do

  let(:recruiter) { create :person }
  let(:candidate) { create :candidate, candidate_availability: available }
  let(:available) { create :candidate_availability, sunday_first: true }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  describe 'GET new' do
    let(:new_availability_candidate) { create :candidate }
    before {
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new,
          candidate_id: new_availability_candidate.id
    }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the confirm template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:new_availability_candidate) { create :candidate }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(create?: true)
      post :create,
           candidate_id: new_availability_candidate.id,
           candidate_availability: {
               monday_first: true,
               monday_second: false,
               monday_third: true
           }
      new_availability_candidate.reload
    end

    it 'creates an availability' do
      expect(CandidateAvailability.count).to eq(1)
    end

    it 'updates the candidates availability' do
      expect(new_availability_candidate.candidate_availability.monday_first).to eq(true)
      expect(new_availability_candidate.candidate_availability.monday_first).to eq(true)
      expect(new_availability_candidate.candidate_availability.monday_third).to eq(true)
      expect(new_availability_candidate.candidate_availability.monday_second).to eq(false)
    end

    it 'renders the candidate show page' do
      expect(response).to redirect_to candidate_path new_availability_candidate
    end

    it 'creates a log entry' do
      expect(LogEntry.count).to be(1)
    end
  end

  describe 'GET edit' do
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
    before(:each) do
      allow(controller).to receive(:policy).and_return double(update?: true)
      patch :update,
            id: available.id,
            candidate_id: candidate.id,
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
end