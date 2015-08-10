# require 'rails_helper'
#

# NOT USING, NOT TESTING
# describe ProfileExperiencesController do
#   let!(:person) { create :it_tech_person }
#   let(:profile) { create :profile, person: person }
#   let(:profile_experience) { build :profile_experience }
#   let(:invalid_profile_experience) { build :profile_experience, started: nil }
#
#   describe 'GET new' do
#     it 'returns a success status' do
#       allow(controller).to receive(:policy).and_return double(new?: true)
#       get :new,
#           profile_id: profile.id
#       expect(response).to be_success
#       expect(response).to render_template(:new)
#     end
#   end
#
#   describe 'POST create success' do
#     it 'creates a profile experience record' do
#       expect {
#         post :create,
#              profile_id: profile.id,
#              profile_experience: profile_experience.attributes
#       }.to change(ProfileExperience, :count).by(1)
#       expect(response).to be_redirect
#     end
#   end
#
#   describe 'POST create failure' do
#     it 'does not create a profile experience record' do
#       post :create, profile_id: profile.id, profile_experience: invalid_profile_experience.attributes
#       expect(response).to render_template(:new)
#     end
#   end
#
#   describe 'GET edit' do
#     it 'returns a success status' do
#       profile_experience.save
#       get :edit,
#           profile_id: profile.id,
#           id: profile_experience.id
#       expect(response).to be_success
#       expect(response).to render_template(:edit)
#     end
#   end
#
#   describe 'PUT update' do
#     it 'updates a profile experience record' do
#       profile_experience.save
#       expect {
#         put :update,
#             profile_id: profile.id,
#             id: profile_experience.id,
#             profile_experience: profile_experience.attributes.
#                 merge(title: 'Chief Amazing Officer')
#         profile_experience.reload
#       }.to change(profile_experience, :title).to('Chief Amazing Officer')
#       expect(response).to be_redirect
#     end
#   end
#
#   describe 'PUT update failure' do
#     it 'does not update a profile experience record' do
#       profile_experience.save
#       put :update,
#           profile_id: profile.id,
#           id: profile_experience.id,
#           profile_experience: invalid_profile_experience.attributes
#       profile_experience.reload
#       expect(response).to render_template(:edit)
#     end
#   end
#
#   describe 'DELETE destroy' do
#     subject { delete :destroy,
#                      profile_id: profile.id,
#                      id: profile_experience.id }
#
#     before(:each) do
#       profile_experience.save
#       request.env['HTTP_REFERER'] = root_path
#     end
#
#     context 'success' do
#       it 'destroys a profile education record' do
#         expect{subject}.to change(ProfileExperience, :count).by(-1)
#         expect(response).to redirect_to(root_path)
#       end
#
#       it 'flashes a deleted notice' do
#         expect(subject.request.flash[:notice]).to eq('Experience deleted!')
#       end
#     end
#
#     context 'failure' do
#       it 'should not destroy a profile education record'
#       it 'should flash an error message'
#     end
#   end
#
# end
