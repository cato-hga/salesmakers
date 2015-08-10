# require 'rails_helper'
#
# describe ProfilesController do
#   let!(:person) { create :it_tech_person }
#   let(:profile) { create :profile, person: person }
#
#   describe 'GET edit' do
#     it 'returns a success status' do
#       allow(controller).to receive(:policy).and_return double(edit?: true)
#       get :edit,
#           id: profile.id
#       expect(response).to be_success
#       expect(response).to render_template(:edit)
#     end
#   end
#
#   describe 'PUT update' do
#     it 'updates a profile' do
#       allow(controller).to receive(:policy).and_return double(update?: true)
#       expect {
#         put :update,
#             id: profile.id,
#             profile: { nickname: 'Admin' }
#         profile.reload
#       }.to change(profile, :nickname).to('Admin')
#       expect(response).to render_template(:edit)
#     end
#   end
# end