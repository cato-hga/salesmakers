require 'rails_helper'

describe PollQuestionsController do

  describe 'GET new' do
    it 'returns a success status' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    let!(:poll_question) { build :poll_question }

    it 'creates a poll question' do
      post :create, poll_question: poll_question.attributes
      expect(response).to redirect_to(poll_questions_path)
      expect(assigns(:poll_question).question).to include("?")
      expect(assigns(:poll_question).question).not_to include("!")
    end
  end

  describe 'GET index' do
    it 'returns a success status' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET edit' do
    let(:poll_question) { create :poll_question }

    it 'returns a success status' do
      get :edit,
          id: poll_question.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT update' do
    let(:poll_question) { create :poll_question }

    it 'updates a poll question' do
      put :update,
          id: poll_question.id,
          poll_question: { help_text: 'This is some changed help text.' }
      expect(response).to redirect_to(poll_questions_path)
    end
  end

end