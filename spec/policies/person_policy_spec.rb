require 'rails_helper'

describe PersonPolicy do

  let(:project) { build_stubbed :project }
  let(:sales_specialist) { build_stubbed :position }
  let(:orlando_area) { create :area, name: 'Orlando Retail Territory', project: project}
  let!(:tampa_person) {
    tampa = create :area, name: 'Tampa Retail Territory', project: project
    person = create :person, position: sales_specialist
    person_area = create :person_area, area: tampa, person: person
    person
  }
  let!(:orlando_person) {
    person = create :person, position: sales_specialist, supervisor: orlando_manager
    person_area = create :person_area, area: orlando_area, person: person
    person
  }

  let(:second_orlando_person) {
    person = create :person, position: sales_specialist
    person_area = create :person_area, area: orlando_area, person: person
    person
  }

  let(:territory_manager) {
    build_stubbed :position,
           name: 'Vonage Territory Manager',
           leadership: true
  }

  let(:orlando_manager) {
    person = create :person,
                    position: territory_manager
    person_area = create :person_area, area: orlando_area, person: person, manages: true
    person
  }

  context 'as a sales rep' do
    it 'should not show someone from another territory' do
      expect(Pundit.policy_scope(tampa_person, Person.all).all).not_to include(orlando_person)
    end

    it 'should show people from the same territory' do
      expect(Pundit.policy_scope(second_orlando_person, Person.all).all).to include(orlando_person)
    end

    it 'should show self' do
      expect(Pundit.policy_scope(tampa_person, Person.all).all).to include(tampa_person)
    end
  end

  context 'as a territory manager' do
    it 'should not show someone from another territory' do
      expect(Pundit.policy_scope(orlando_manager, Person.all).all).not_to include(tampa_person)
    end

    it 'should show a rep within my territory' do
      expect(Pundit.policy_scope(orlando_manager, Person.all).all).to include(orlando_person)
    end
  end
end