require 'rails_helper'

describe CandidateNotesController do
  let(:recruiter) { create :person }
  let!(:candidate) { create :candidate }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  describe 'POST create' do
    before do
      post :create,
           candidate_id: candidate.id,
           candidate_note: {
               note: 'This is a note.'
           }
    end

    it 'redirects to the candidate show page' do
      expect(response).to redirect_to(candidate_path(candidate))
    end

    it 'increases the CandidateNote count' do
      expect(CandidateNote.count).to eq(1)
    end
  end
end