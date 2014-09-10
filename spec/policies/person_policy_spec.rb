# require 'rails_helper'
#
# RSpec.describe PersonPolicy do
#
#   let(:position) { create :position }
#   let(:person_viewing) { create :person, position: position }
#   let(:person_viewed) {
#     area = create :area, name: 'Orlando Retail Territory'
#     person = create :person, position: position
#     person_area = create :person_area, area: area, person: person
#     person
#   }
#
#   it 'should not show people in areas that a person does not have permission to view' do
#     expect(Pundit.policy_scope(person_viewing, Person.all).all).not_to include(person_viewed)
#   end
#
#   #TODO WHY U NO PASS
#   it 'should show self' do
#     expect(Pundit.policy_scope(person_viewing, Person.all).all).to include(person_viewing)
#   end
# end