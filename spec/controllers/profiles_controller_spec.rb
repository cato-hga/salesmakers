require 'rails_helper'

describe ProfilesController do
  let(:profile) { Profile.first }

  describe 'GET edit' do
    it 'returns a success status' do
      get :edit,
          id: profile.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT update' do
    it 'updates a profile' do
      expect {
        put :update,
            id: profile.id,
            profile: { nickname: 'Admin' }
        profile.reload
      }.to change(profile, :nickname).to('Admin')
      expect(response).to render_template(:edit)
    end
  end
end