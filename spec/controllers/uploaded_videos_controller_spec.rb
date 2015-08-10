# require 'rails_helper'

# Cannot be easily decoupled from administrator person - commenting out

# describe UploadedVideosController do
#   let(:uploaded_video) { build :uploaded_video }
#   let(:show_video) { create :uploaded_video }
#   let(:wall) { create :person_wall }
#
#   describe 'POST create' do
#     it 'creates an uploaded video and renders :show' do
#       expect {
#         post :create,
#              uploaded_video: uploaded_video.attributes.
#                  merge(wall_id: wall.id)
#       }.to change(UploadedVideo, :count).by(1)
#       expect(response).to be_success
#       expect(response).to render_template(:show)
#     end
#   end
#
#   describe 'GET show' do
#     it 'returns the correct uploaded video' do
#       get :show, id: show_video.id
#       expect(response).to render_template(:show)
#     end
#   end
# end