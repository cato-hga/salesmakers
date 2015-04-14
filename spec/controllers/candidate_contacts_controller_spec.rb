require 'rails_helper'

describe CandidateContactsController do
  let(:recruiter) { create :person }
  let!(:candidate) { create :candidate }
  let(:note) { 'Because I feel like it' }

  describe 'GET new_call' do
    before { get :new_call, candidate_id: candidate.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new_call template' do
      expect(response).to render_template(:new_call)
    end
  end

  describe 'POST create' do
    before do
      allow(controller).to receive(:policy).and_return double(create?: true)
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      post :create,
           candidate_id: candidate.id,
           candidate_contact: {
               contact_method: 'phone',
               notes: note
           }
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'creates the candidate contact' do
      expect(CandidateContact.count).to eq(1)
    end

    it 'returns the candidate contact ID' do
      expect(response.body).to eq(CandidateContact.first.id.to_s)
    end
  end

  describe 'PUT save_call_results' do
    let(:candidate) { create :candidate }
    let!(:candidate_contact) { create :candidate_contact, candidate: candidate }

    before do
      allow(controller).to receive(:policy).and_return double(save_call_results?: true)
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      put :save_call_results,
          candidate_id: candidate.id,
          candidate_contact_id: candidate_contact.id,
          call_results: 'Here is a sample result note'
    end

    it 'redirects to the candidate show page' do
      expect(response).to redirect_to(candidate_path(candidate))
    end
  end
end