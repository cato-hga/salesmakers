# require 'rails_helper'
#
# describe 'PollQuestions CRUD actions' do
#   let!(:it_tech) { create :it_tech_person }
#   let(:permission_manage) { create :permission, key: 'poll_question_manage' }
#   let(:permission_show) { create :permission, key: 'poll_question_show' }
#   before(:each) do
#     it_tech.position.permissions << permission_manage
#     it_tech.position.permissions << permission_show
#     CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
#   end
#
#   describe 'have the correct page headings' do
#     specify 'for new' do
#       visit new_poll_question_path
#       expect(page).to have_selector('h1', text: 'New Poll Question')
#     end
#
#     specify 'for index' do
#       visit poll_questions_path
#       expect(page).to have_selector('h1', text: 'Poll Questions')
#     end
#
#     specify 'for edit' do
#       poll_question = create :poll_question
#       visit edit_poll_question_path(poll_question)
#       expect(page).to have_selector('h1', text: poll_question.question)
#     end
#   end
#
#   context 'for creating' do
#     let(:poll_question) {
#       build :poll_question,
#             help_text: 'This is some sample help text so you can rest easy.',
#             end_time: Time.now + 1.day,
#             active: true
#     }
#
#     it 'creates a new poll question with minimal values' do
#       visit poll_questions_path
#       click_on 'new_action_button'
#       fill_in 'Question', with: poll_question.question
#       fill_in 'Start time', with: poll_question.start_time.strftime('%m/%d/%Y %-l:%M%P')
#       click_on 'Save'
#       visit poll_questions_path
#       expect(page).to have_content poll_question.question
#     end
#
#     it 'creates a new poll question with all values' do
#       visit poll_questions_path
#       click_on 'new_action_button'
#       fill_in 'Question', with: poll_question.question
#       fill_in 'Help text', with: poll_question.help_text
#       fill_in 'Start time', with: poll_question.start_time.strftime('%m/%d/%Y %-l:%M%P')
#       fill_in 'End time', with: poll_question.end_time.strftime('%m/%d/%Y %-l:%M%P')
#       check 'Active'
#       click_on 'Save'
#       visit poll_questions_path
#       expect(page).to have_content poll_question.question
#       expect(page).to have_content Date.today.strftime('%m/%d/%Y')
#     end
#   end
#
#   context 'for reading' do
#     let!(:poll_question) { create :poll_question }
#
#     it 'displays a question on index' do
#       visit poll_questions_path
#       expect(page).to have_content poll_question.question
#     end
#   end
#
#   context 'for updating' do
#     let!(:poll_question) { create :poll_question }
#
#     it 'allows a poll question to be updated' do
#       visit poll_questions_path
#       within '.widgets .widget:first-of-type' do
#         click_on 'Edit'
#       end
#       fill_in 'Help text', with: 'This is changed help text.'
#       click_on 'Save'
#       expect(page).to have_content('This is changed help text.')
#     end
#   end
#
#   context 'for destroying' do
#     let(:poll_question) { build :poll_question }
#
#     it 'deletes a poll question' do
#       poll_question.save
#       question = poll_question.question
#       visit poll_questions_path
#       within '.widgets .widget:first-of-type h3' do
#         click_on 'Delete'
#       end
#       expect(page).not_to have_content(question)
#     end
#
#     it 'does not allow an answered question to be destroyed' do
#       poll_question_choice = create :poll_question_choice
#       poll_question = poll_question_choice.poll_question
#       person = Person.first
#       poll_question_choice.people << person
#       visit poll_questions_path
#       within '.widgets .widget:first-of-type h3' do
#         expect(page).not_to have_content('Delete')
#       end
#     end
#   end
#
# end