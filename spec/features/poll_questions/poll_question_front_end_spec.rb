require 'rails_helper'

describe 'Front-end poll question behavior' do
  let(:poll_question_choice) { create :poll_question_choice }

  context 'without an answer from the current person' do
    # Commented out - not utilized
    # it 'displays the question on the home page' do
    #   poll_question = poll_question_choice.poll_question
    #   visit root_path
    #   expect(page).to have_content poll_question.question
    # end

    it 'accepts an answer and displays results',
       pending: 'js: true does not work as expected' do
      poll_question = poll_question_choice.poll_question
      visit root_path
      within '.poll_question:first-of-type' do
        choose 'poll_question_' + poll_question.id.to_s + '_choice_' +
                   poll_question_choice.id.to_s
        click_on 'Submit'
      end
      expect(page).to have_content('Results')
    end
  end

  context 'with an answer from the current person' do
    let(:person) { Person.first }

    it 'does not show the poll question on the home screen' do
      poll_question = poll_question_choice.poll_question
      person.poll_question_choices << poll_question_choice
      visit root_path
      expect(page).not_to have_content(poll_question.question)
    end
  end

end