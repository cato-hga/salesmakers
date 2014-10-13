require 'rails_helper'

describe 'PollQuestions CRUD actions' do

  describe 'have the correct page headings' do
    specify 'for new' do
      visit new_poll_question_path
      expect(page).to have_selector('h1', text: 'New Poll Question')
    end

    specify 'for index' do
      visit poll_questions_path
      expect(page).to have_selector('h1', text: 'Poll Questions')
    end
  end

  describe 'for creating' do
    let(:poll_question) {
      build :poll_question,
            help_text: 'This is some sample help text so you can rest easy.',
            end_time: Time.now + 1.day,
            active: true
    }

    it 'creates a new poll question with minimal values' do
      visit new_poll_question_path
      fill_in 'Question', with: poll_question.question
      fill_in 'Start time', with: poll_question.start_time.strftime('%m/%d/%Y %-l:%M%P')
      click_on 'Save'
      visit poll_questions_path
      expect(page).to have_content poll_question.question
    end

    it 'creates a new poll question with all values' do
      visit new_poll_question_path
      fill_in 'Question', with: poll_question.question
      fill_in 'Help text', with: poll_question.help_text
      fill_in 'Start time', with: poll_question.start_time.strftime('%m/%d/%Y %-l:%M%P')
      fill_in 'End time', with: poll_question.end_time.strftime('%m/%d/%Y %-l:%M%P')
      check 'Active'
      click_on 'Save'
      visit poll_questions_path
      expect(page).to have_content poll_question.question
      expect(page).to have_content Date.today.strftime('%m/%d/%Y')
    end
  end

  describe 'for reading' do
    let!(:poll_question) { create :poll_question }

    it 'displays a question on index' do
      visit poll_questions_path
      expect(page).to have_content poll_question.question
    end
  end

end