# require 'rails_helper'
#
# describe 'relationship between people and poll question choices' do
#
#   let(:person) { create :person }
#   let(:poll_question_choice) { create :poll_question_choice }
#
#   specify { expect(person).to respond_to(:poll_question_choices) }
#   specify { expect(poll_question_choice).to respond_to(:people) }
#
#   it 'saves a poll question choice to a person' do
#     expect {
#       person.poll_question_choices << poll_question_choice
#     }.to change(person.poll_question_choices, :count).by(1)
#   end
#
#   it 'saves a person to a poll question choice' do
#     expect {
#       poll_question_choice.people << person
#     }.to change(poll_question_choice.people, :count).by(1)
#   end
#
# end