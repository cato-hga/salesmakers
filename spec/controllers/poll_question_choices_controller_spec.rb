require 'rails_helper'

describe PollQuestionChoicesController do
  let(:poll_question_choice) { build :poll_question_choice }

  describe 'POST create' do
    it 'creates poll question choices' do
      expect {
        post :create,
             poll_question_id: poll_question_choice.poll_question.id,
             poll_question_choice: poll_question_choice.attributes
      }.to change(PollQuestionChoice, :count).by(1)
      expect(response).to be_success
    end
  end

  describe 'PUT update' do
    it 'updates a poll question choice' do
      poll_question_choice.save
      expect {
        put :update,
            poll_question_id: poll_question_choice.poll_question.id,
            id: poll_question_choice.id,
            poll_question_choice: {
                help_text: 'This is some new help text.'
            }
        poll_question_choice.reload
      }.to change(poll_question_choice, :help_text).
               to('This is some new help text.')
      expect(response).to be_success
    end

    it 'does not allow an answered choice to be edited' do
      poll_question_choice.save
      person = Person.first
      poll_question_choice.people << person
      expect {
        put :update,
            poll_question_id: poll_question_choice.poll_question.id,
            id: poll_question_choice.id,
            poll_question_choice: {
                help_text: 'This is some new help text.'
            }
        poll_question_choice.reload
      }.not_to change(poll_question_choice, :help_text)
      expect(response).to redirect_to(poll_questions_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a poll question choice' do
      poll_question_choice.save
      expect {
        delete :destroy,
               poll_question_id: poll_question_choice.poll_question.id,
               id: poll_question_choice.id
      }.to change(PollQuestionChoice, :count).by(-1)
      expect(response).to redirect_to(poll_questions_path)
    end

    it 'does not delete an answered poll_question_choice' do
      poll_question_choice.save
      person = Person.first
      poll_question_choice.people << person
      expect {
        delete :destroy,
               poll_question_id: poll_question_choice.poll_question.id,
               id: poll_question_choice.id
      }.not_to change(PollQuestionChoice, :count)
    end
  end

  describe 'GET choose' do
    let!(:person) { Person.first }

    it 'allows a person to answer a poll they have not answered yet' do
      poll_question_choice.save
      poll_question = poll_question_choice.poll_question
      expect {
        get :choose,
            id: poll_question_choice.id,
            poll_question_id: poll_question.id
        person.reload
      }.to change(person.poll_question_choices, :count).by(1)
      expect(response).to redirect_to(poll_question_path(poll_question))
    end

    it 'does not allow a person to answer a question more than once'
  end

end