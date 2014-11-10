require 'rails_helper'

describe 'ProfileExperiencesController CRUD actions' do

  let(:profile) { Profile.first }
  let(:profile_experience) { build :profile_experience }

  context 'destroying' do
    subject { delete :destroy, profile_experience }
    describe 'success' do
      expect(subject.request.flash[:success]).to be_nil
    end
  end

end