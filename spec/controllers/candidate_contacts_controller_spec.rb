require 'rails_helper'

describe CandidateContactsController do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
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
  end
end