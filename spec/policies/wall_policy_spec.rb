require 'rails_helper'

describe WallPolicy do

  describe 'visibility' do

    let(:client) { create :client }
    let(:project) { create :project, client: client }
    let(:territory) { create :area_type, name: 'Test Territory', project: project }
    let(:area) { create :area, area_type: territory, project: project }
    let(:field_department) { create :department }
    let(:field_position) { create :position, department: field_department }
    let(:field_person) { create :person, position: field_position }
    let(:person_wall) { create :person_wall}
    let(:field_person_area) { create :person_area, person: field_person, area: area }

    it 'should include my own wall' do
      field_person.wall = person_wall
      expect(Pundit.policy_scope(field_person, Wall.all).all).to include(field_person.wall)
    end

    context 'as an HQ employee' do
      it 'should include my department wall' do
      end

      it 'should NOT include other department walls' do
      end

      it 'should include all area and project walls' do
      end
    end

    context 'as a field employee' do
      it 'should include all area walls in my person_area(s)' do
      end

      it 'should include all ancestors for my area' do
      end
    end

    context 'as somebody with all_walls_permission' do
      it 'should include ALL walls' do
      end
    end
  end
end
