require 'rails_helper'

describe ProjectPolicy do

  let(:sprint_project) { create :project, name: 'Sprint Retail'}
  let(:vonage_retail_project) { create :project, name: 'Vonage Retail' }

  let(:tampa) { create :area, project: vonage_retail_project }

  let(:sales_specialist) { create :position }
  let(:software_developer) {
    create :position,
            name: 'Software Development',
            hq: true }
  let!(:tampa_person) {
    person = create :person, position: sales_specialist
    person_area = create :person_area, area: tampa, person: person
    person
  }

  let(:hq_employee) { create :person, position: software_developer }

  context 'as a sales rep' do
    it 'should not show projects other than an employees own' do
      expect(Pundit.policy_scope(tampa_person, Project.all)).not_to include(sprint_project)
    end

    it 'should show the parent project' do
      expect(Pundit.policy_scope(tampa_person, Project.all)).to include(vonage_retail_project)
    end
  end

  context 'as an HQ employee' do
    it 'should show all projects' do #TODO: Refactor this test so it doesn't make the testing gods cry. I'm certain there is a more elegant way to handle this
      expect(Pundit.policy_scope(hq_employee, Project.all)).to include(vonage_retail_project)
      expect(Pundit.policy_scope(hq_employee, Project.all)).to include(sprint_retail_project)
    end
  end
end
