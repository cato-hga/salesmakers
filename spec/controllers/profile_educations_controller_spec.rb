require 'rails_helper'

describe ProfileEducationsController do
  let(:profile) { Profile.first }

  describe 'GET new' do
    it 'should return a success status' do
      get :new,
          profile_id: profile.id
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:profile_education) { build :profile_education }

    it 'creates a profile education record' do
      expect {
        post :create,
             profile_id: profile.id,
             profile_education: profile_education.attributes
      }.to change(ProfileEducation, :count).by(1)
      expect(response).to be_redirect
    end
  end

  describe 'GET edit' do
    let(:profile_education) { create :profile_education }

    it 'returns a success status' do
      get :edit,
          profile_id: profile.id,
          id: profile_education.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT update' do
    let!(:profile_education) { create :profile_education, profile_id: profile.id }

    it 'returns updates a profile education record' do
      expect {
        put :update,
            profile_id: profile.id,
            id: profile_education.id,
            profile_education: { school: 'USF Saint Petersburg' }
        profile_education.reload
      }.to change(profile_education, :school).to('USF Saint Petersburg')
      expect(response).to be_redirect
    end
  end

  describe 'DELETE destroy' do
    let!(:profile_education) { create :profile_education }

    it 'deletes a profile education record' do
      request.env['HTTP_REFERER'] = root_path
      expect {
        delete :destroy,
               profile_id: profile.id,
               id: profile_education.id
      }.to change(ProfileEducation, :count).by(-1)
    end
  end

end