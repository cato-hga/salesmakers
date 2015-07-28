require 'rails_helper'

describe RosterVerificationSessionsController do
  let(:creator) { create :person }
  let(:person) { create :person }

  before { CASClient::Frameworks::Rails::Filter.fake(creator.email) }

  describe 'GET new' do
    before { get :new }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    subject do
      post :create,
           roster_verification_session: {
               creator_id: creator.id,
               roster_verifications_attributes: [
                   {
                       status: 'active',
                       person_id: person.id,
                       creator_id: creator.id
                   }
               ]
           }
    end

    it 'redirects to root_path' do
      subject
      expect(response).to redirect_to root_path
    end

    it 'creates a RosterVerificationSession' do
      expect { subject }.to change(RosterVerificationSession, :count).by 1
    end

    it 'creates a RosterVerification' do
      expect { subject }.to change(RosterVerification, :count).by 1
    end

    it 'creates a LogEntry' do
      expect { subject }.to change(LogEntry, :count).by 1
    end
  end
end