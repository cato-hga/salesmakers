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

    it 'creates a project' do
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

  describe 'GET edit', :pending do
    it 'returns a success status' do
      get :edit, id: 1
      expect(response).to be_success
    end
  end

end