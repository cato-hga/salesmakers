# require 'rails_helper'
#
# describe 'PollQuestionChoices CRUD actions' do
#   let!(:it_tech) { create :it_tech_person }
#   let(:permission_manage) { create :permission, key: 'poll_question_manage' }
#   let(:permission_show) { create :permission, key: 'poll_question_show' }
#   before(:each) do
#     it_tech.position.permissions << permission_manage
#     it_tech.position.permissions << permission_show
#     CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
#   end
#
#   context 'for creating' do
#     let!(:poll_question) { create :poll_question }
#     let(:poll_question_choice) { build :poll_question_choice }
#
#     it 'creates a new poll question choice with minimal values' do
#       visit poll_questions_path
#       within '.widgets .widget:first-of-type .choices' do
#         fill_in 'Name', with: poll_question_choice.name
#         click_on 'Add'
#       end
#       visit poll_questions_path
#       expect(page).to have_content(poll_question_choice.name)
#     end
#   end
#
#   context 'for updating' do
#     let!(:poll_question_choice) { create :poll_question_choice }
#
#     it 'updates a poll question choice' do
#       name = 'Changed poll question choice'
#       description = 'This is an added description.'
#       visit poll_questions_path
#       within '.widgets .widget:first-of-type .choices .choice:first-of-type' do
#         click_on 'Edit'
#         fill_in 'Name', with: name
#         fill_in 'Help text', with: description
#         click_on 'Save'
#       end
#       visit poll_questions_path
#       expect(page).to have_content(name)
#       expect(page).to have_content(description)
#     end
#
#     it 'does not allow editing an answered choice' do
#       person = Person.first
#       poll_question_choice.people << person
#       visit poll_questions_path
#       within '.widgets .widget:first-of-type .choices .choice:first-of-type' do
#         expect(page).not_to have_selector('a', text: 'Edit')
#       end
#     end
#   end
#
#   context 'for destroying' do
#     let!(:poll_question_choice) { create :poll_question_choice }
#
#     it 'destroys a poll question choice' do
#       visit poll_questions_path
#       choice_name = poll_question_choice.name
#       within '.widgets .widget:first-of-type .choices .choice:first-of-type' do
#         click_on 'Delete'
#       end
#       expect(page).not_to have_content(choice_name)
#     end
#
#     it 'does not allow destruction of an answered choice' do
#       person = Person.first
#       poll_question_choice.people << person
#       visit poll_questions_path
#       within '.widgets .widget:first-of-type .choices .choice:first-of-type' do
#         expect(page).not_to have_content('Delete')
#       end
#     end
#   end
#
# end