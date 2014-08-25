require 'rails_helper'

RSpec.describe PersonPolicy do

  let(:person_viewing) { create :person }
  let(:person_viewed) {
    area = create :area, name: 'Orlando Retail Territory'
    person = create :person
    person_area = create :person_area, area: area, person: person
    person
  }

  it 'should not show people in areas that a person does not have permission to view' do
    expect(Pundit.policy_scope(person_viewing, Person.all).all).not_to include(person_viewed)
  end

  it 'should show self' do
    expect(Pundit.policy_scope(person_viewing, Person.all).all).to include(person_viewing)
  end
end