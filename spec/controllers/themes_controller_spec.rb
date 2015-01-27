# require 'rails_helper'
#
# describe ThemesController do
#   let(:theme) { build :theme }
#
#   describe 'GET index' do
#     it 'should return a success status' do
#       get :index
#       expect(response).to be_success
#       expect(response).to render_template(:index)
#     end
#   end
#
#   describe 'GET new' do
#     it 'should return a success status' do
#       get :new
#       expect(response).to be_success
#       expect(response).to render_template(:new)
#     end
#   end
#
#   describe 'POST create' do
#     it 'should create a theme' do
#       expect {
#         post :create,
#              theme: theme.attributes
#       }.to change(Theme, :count).by(1)
#     end
#   end
#
#   describe 'GET edit' do
#     it 'should return a success status' do
#       theme.save
#       get :edit,
#           id: theme.id
#       expect(response).to be_success
#       expect(response).to render_template(:edit)
#     end
#   end
#
#   describe 'PUT update' do
#     it 'should update a theme' do
#       theme.save
#       expect {
#         put :update,
#             id: theme.id,
#             theme: { name: 'awesome' }
#         theme.reload
#       }.to change(theme, :name).to('awesome')
#       expect(response).to redirect_to(themes_path)
#     end
#   end
#
# end