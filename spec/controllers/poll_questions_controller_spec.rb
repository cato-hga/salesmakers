# require 'rails_helper'
#
# describe PollQuestionsController do
#
#   describe 'GET new' do
#     it 'returns a success status' do
#       allow(controller).to receive(:policy).and_return double(new?: true)
#       get :new
#       expect(response).to be_success
#     end
#   end
#
#   describe 'POST create' do
#     let!(:poll_question) { build :poll_question }
#
#     it 'creates a poll question' do
#       allow(controller).to receive(:policy).and_return double(create?: true)
#       post :create, poll_question: poll_question.attributes
#       expect(response).to redirect_to(poll_questions_path)
#       expect(assigns(:poll_question).question).to include("?")
#       expect(assigns(:poll_question).question).not_to include("!")
#     end
#   end
#
#   describe 'GET index' do
#     it 'returns a success status' do
#       allow(controller).to receive(:policy).and_return double(index?: true)
#       get :index
#       expect(response).to be_success
#     end
#   end
#
#   describe 'GET show' do
#     let!(:poll_question) { create :poll_question }
#
#     it 'returns a success status' do
#       allow(controller).to receive(:policy).and_return double(show?: true)
#       get :show,
#           id: poll_question.id
#       expect(response).to be_success
#       expect(response).to render_template(:show)
#     end
#
#   end
#
#   describe 'GET edit' do
#     let(:poll_question) { create :poll_question }
#
#     it 'returns a success status' do
#       allow(controller).to receive(:policy).and_return double(edit?: true)
#       get :edit,
#           id: poll_question.id
#       expect(response).to be_success
#       expect(response).to render_template(:edit)
#     end
#   end
#
#   describe 'PUT update' do
#     let(:poll_question) { create :poll_question }
#
#     it 'updates a poll question' do
#       allow(controller).to receive(:policy).and_return double(update?: true)
#       put :update,
#           id: poll_question.id,
#           poll_question: { help_text: 'This is some changed help text.' }
#       expect(response).to redirect_to(poll_questions_path)
#     end
#   end
#
#   describe 'DELETE destroy' do
#     let!(:poll_question) { create :poll_question }
#
#     it 'deletes a poll question' do
#       allow(controller).to receive(:policy).and_return double(destroy?: true)
#       expect {
#         delete :destroy,
#                id: poll_question.id
#       }.to change(PollQuestion, :count).by(-1)
#       expect(response).to redirect_to(poll_questions_path)
#     end
#   end
#
# end