require 'rails_helper'

describe PollQuestionsController do

  describe 'POST create' do
    let!(:poll_question) { build :poll_question }

    it 'creates a project' do
      post :create, poll_question: poll_question.attributes
      expect(response).to redirect_to(poll_questions_path)
      expect(assigns(:poll_question).question).to include("?")
      expect(assigns(:poll_question).question).not_to include("!")
    end
  end

end