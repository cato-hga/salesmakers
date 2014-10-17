require 'rails_helper'

describe ProfileExperiencesController do
  let(:profile) { Profile.first }
  let(:profile_experience) { build :profile_experience }

  describe 'GET new' do
    it 'returns a success status' do
      get :new,
          profile_id: profile.id
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    it 'creates a profile experience record' do
      expect {
        post :create,
             profile_id: profile.id,
             profile_experience: profile_experience.attributes
      }.to change(ProfileExperience, :count).by(1)
      expect(response).to be_redirect
    end
  end

  describe 'GET edit' do
    it 'returns a success status' do
      profile_experience.save
      get :edit,
          profile_id: profile.id,
          id: profile_experience.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT update' do
    it 'updates a profile experience record' do
      profile_experience.save
      expect {
        put :update,
            profile_id: profile.id,
            id: profile_experience.id,
            profile_experience: profile_experience.attributes.
                merge(title: 'Chief Amazing Officer')
        profile_experience.reload
      }.to change(profile_experience, :title).to('Chief Amazing Officer')
      expect(response).to be_redirect
    end
  end

  describe 'DELETE destroy' do
    it 'destroys a profile education record' do
      profile_experience.save
      request.env['HTTP_REFERER'] = root_path
      expect {
        delete :destroy,
               profile_id: profile.id,
               id: profile_experience.id
      }.to change(ProfileExperience, :count).by(-1)
      expect(response).to redirect_to(root_path)
    end
  end
end