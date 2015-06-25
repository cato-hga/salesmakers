# == Schema Information
#
# Table name: areas
#
#  id                               :integer          not null, primary key
#  name                             :string           not null
#  area_type_id                     :integer          not null
#  ancestry                         :string
#  created_at                       :datetime
#  updated_at                       :datetime
#  project_id                       :integer          not null
#  connect_salesregion_id           :string
#  personality_assessment_url       :string
#  area_candidate_sourcing_group_id :integer
#  email                            :string
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Area, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:area_type) }

  it { should belong_to(:area_type) }
  it { should belong_to(:project) }
  it { should have_many(:person_areas) }
  it { should have_many(:people).through(:person_areas) }
  #it { should have_one(:wall) }

  # Scope isn't currently used. Test will pass once uncommented
  # describe 'member_of scope' do
  #   let(:hq_person) { Person.first }
  #   let(:non_hq_area) { create :area }
  #   let(:non_hq_person) { create :person }
  #   let!(:non_hq_person_area) { create :person_area, area: non_hq_area, person: non_hq_person}
  #
  #   context 'for HQ employees' do
  #     it 'should return all areas a person is a member of' do
  #       expect(Area.member_of(hq_person)).not_to be_nil
  #     end
  #   end
  #
  #   context 'for non-hq employees' do
  #     it 'should return all areas a person is a member of' do
  #       expect(Area.member_of(non_hq_person)).not_to be_nil
  #     end
  #   end
  # end

  #TODO: Refactor the following two specs to use the RSPEC LET method
  it ' project_roots scope should return project_roots' do
    proj = Project.first
    expect(Area.project_roots(proj)).not_to be_nil
  end

  it 'responds to personality_assessment_url' do
    area = build :area
    expect(area).to respond_to(:personality_assessment_url)
  end

  it 'responds to area_candidate_sourcing_group' do
    area = build :area
    expect(area).to respond_to(:area_candidate_sourcing_group)
  end

  it 'managers method should return all areas that a person manages' do
    person = create :person
    area = create :area
    p_a = create(:person_area, person: person, area: area, manages: true)
    expect(area.managers).not_to be_nil
  end

  describe 'non_managers method' do
    let(:area) { create :area }
    let(:inactive_person) { create :person, active: false }
    let(:active_person) { create :person }
    let!(:person_area) { create :person_area, person: active_person, area: area }
    let!(:inactive_person_area) { create :person_area, person: inactive_person, area: area}

    context 'for only active employees' do
      it 'should return all active, non-managers of a given area' do
        non_managers_count = area.non_managers.where(active: true).count
        expect(non_managers_count).to eq(1)
      end
    end

    context 'for inactive and active employees' do
      it 'should return all non-managers of a given area' do
        non_managers_count = area.non_managers.count
        expect(non_managers_count).to eq(2)
      end
    end
  end

  describe 'locations' do
    let(:area_one) { create :area }
    let(:area_two) { create :area, name: 'Area Two' }
    let(:location_one) { create :location }
    let(:location_two) { create :location }
    let!(:location_area_one) {
      create :location_area,
             location: location_one,
             area: area_one
    }
    let!(:location_area_two) {
      create :location_area,
             location: location_two,
             area: area_two
    }

    before do
      area_two.update parent: area_one
    end

    it 'returns only the locations in the area with #locations' do
      expect(area_one.locations.count).to eq(1)
    end

    it 'returns all locations in the tree for #all_locations' do
      expect(area_one.all_locations.count).to eq(2)
    end
  end

  describe 'visibility scope' do
    let(:foo_project) { create :project, name: 'Project Foo' }
    let(:bar_project) { create :project, name: 'Project Bar' }
    let(:foo_root) {
      create :area,
             name: 'Foo Root Area',
             project: foo_project
    }
    let(:bar_root) {
      create :area,
             name: 'Bar Root Area',
             project: bar_project
    }
    let(:foo_root_child) {
      create :area,
             name: 'Foo Root Child',
             project: foo_project
    }
    let(:bar_root_child) {
      create :area,
             name: 'Bar Root Child',
             project: bar_project
    }
    let(:foo_root_child_child) {
      create :area,
             name: 'Foo Root Child Child',
             project: foo_project
    }
    let(:bar_root_child_child) {
      create :area,
             name: 'Bar Root Child Child',
             project: bar_project
    }
    let(:hq_department) {
      create :department,
             name: 'Headquarters'
    }
    let(:other_hq_department) {
      create :department,
             name: 'Other Headquarters'
    }
    let(:field_department) {
      create :department,
             name: 'Field'
    }
    let(:field_position) {
      create :position,
             hq: false,
             all_field_visibility: false,
             all_corporate_visibility: false,
             department: field_department
    }
    let(:hq_position) {
      create :position,
             hq: true,
             field: false,
             all_field_visibility: false,
             all_corporate_visibility: false,
             department: hq_department
    }
    let(:other_hq_position) {
      create :position,
             hq: true,
             field: false,
             all_field_visibility: false,
             all_corporate_visibility: false,
             department: other_hq_department
    }
    let(:all_field_position) {
      create :position,
             hq: false,
             all_field_visibility: true,
             all_corporate_visibility: false,
             department: field_department
    }
    let(:all_corporate_position) {
      create :position,
             hq: false,
             field: false,
             all_field_visibility: false,
             all_corporate_visibility: true,
             department: hq_department
    }
    let(:everything_position) {
      create :position,
             hq: true,
             field: true,
             all_field_visibility: true,
             all_corporate_visibility: true,
             department: hq_department
    }
    let(:foo_root_manager) {
      create :person,
             position: field_position
    }
    let!(:foo_root_manager_person_area) {
      create :person_area,
             person: foo_root_manager,
             area: foo_root,
             manages: true
    }
    let(:bar_root_manager) {
      create :person,
             position: field_position
    }
    let!(:bar_root_manager_person_area) {
      create :person_area,
             person: bar_root_manager,
             area: bar_root,
             manages: true
    }
    let(:foo_root_child_manager) {
      create :person,
             position: field_position,
             supervisor: foo_root_manager
    }
    let!(:foo_root_child_manager_person_area) {
      create :person_area,
             person: foo_root_child_manager,
             area: foo_root_child,
             manages: true
    }
    let(:bar_root_child_manager) {
      create :person,
             position: field_position,
             supervisor: bar_root_manager
    }
    let!(:bar_root_child_manager_person_area) {
      create :person_area,
             person: bar_root_child_manager,
             area: bar_root_child,
             manages: true
    }
    let(:foo_root_child_child_manager) {
      create :person,
             position: field_position,
             supervisor: foo_root_child_manager
    }
    let!(:foo_root_child_child_manager_person_area) {
      create :person_area,
             person: foo_root_child_child_manager,
             area: foo_root_child_child,
             manages: true
    }
    let(:bar_root_child_child_manager) {
      create :person,
             position: field_position,
             supervisor: bar_root_child_manager
    }
    let!(:bar_root_child_child_manager_person_area) {
      create :person_area,
             person: bar_root_child_child_manager,
             area: bar_root_child_child,
             manages: true
    }
    let(:foo_rep) {
      create :person,
             supervisor: foo_root_child_child_manager,
             position: field_position
    }
    let!(:foo_rep_person_area) {
      create :person_area,
             person: foo_rep,
             area: foo_root_child_child
    }
    let(:bar_rep) {
      create :person,
             supervisor: bar_root_child_child_manager,
             position: field_position
    }
    let!(:bar_rep_person_area) {
      create :person_area,
             person: bar_rep,
             area: bar_root_child_child
    }
    let!(:hq_manager) {
      create :person,
             position: hq_position
    }
    let!(:hq_employee) {
      create :person,
             supervisor: hq_manager,
             position: hq_position
    }
    let!(:other_hq_employee) {
      create :person,
             position: other_hq_position
    }
    let!(:all_field_employee) {
      create :person,
             position: all_field_position
    }
    let!(:all_corporate_employee) {
      create :person,
             position: all_corporate_position
    }
    let!(:everything_employee) {
      create :person,
             position: everything_position
    }

    before do
      foo_root_child.update parent: foo_root
      bar_root_child.update parent: bar_root
      foo_root_child_child.update parent: foo_root_child
      bar_root_child_child.update parent: bar_root_child
    end

    it 'returns no people if a person is not given as a parameter' do
      expect(Area.visible).to be_empty
    end

    context 'as a rep' do
      let!(:visible) { Area.visible(foo_rep) }

      it 'has the proper count' do
        expect(visible.count).to eq(1)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root_child_child)
      end

      it 'excludes the areas that should not be visible' do
        expect(visible).not_to include(foo_root)
        expect(visible).not_to include(foo_root_child)
        expect(visible).not_to include(bar_root)
        expect(visible).not_to include(bar_root_child)
        expect(visible).not_to include(bar_root_child_child)
      end
    end

    context 'as a root-child-child manager' do
      let!(:visible) { Area.visible(foo_root_child_child_manager) }

      it 'has the proper count' do
        expect(visible.count).to eq(1)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root_child_child)
      end

      it 'excludes the areas that should not be visible' do
        expect(visible).not_to include(foo_root)
        expect(visible).not_to include(foo_root_child)
        expect(visible).not_to include(bar_root)
        expect(visible).not_to include(bar_root_child)
        expect(visible).not_to include(bar_root_child_child)
      end
    end

    context 'as a root-child manager' do
      let!(:visible) { Area.visible(foo_root_child_manager) }

      it 'has the proper count' do
        expect(visible.count).to eq(2)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root_child)
        expect(visible).to include(foo_root_child_child)
      end

      it 'excludes the areas that should not be visible' do
        expect(visible).not_to include(foo_root)
        expect(visible).not_to include(bar_root)
        expect(visible).not_to include(bar_root_child)
        expect(visible).not_to include(bar_root_child_child)
      end
    end

    context 'as a root manager' do
      let!(:visible) { Area.visible(foo_root_manager) }

      it 'has the proper count' do
        expect(visible.count).to eq(3)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root)
        expect(visible).to include(foo_root_child)
        expect(visible).to include(foo_root_child_child)
      end

      it 'excludes the areas that should not be visible' do
        expect(visible).not_to include(bar_root)
        expect(visible).not_to include(bar_root_child)
        expect(visible).not_to include(bar_root_child_child)
      end
    end

    context 'as an HQ manager' do
      let!(:visible) { Area.visible(hq_manager) }

      it 'has the proper count' do
        expect(visible.count).to eq(6)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root)
        expect(visible).to include(foo_root_child)
        expect(visible).to include(foo_root_child_child)
        expect(visible).to include(bar_root)
        expect(visible).to include(bar_root_child)
        expect(visible).to include(bar_root_child_child)
      end
    end

    context 'as an HQ employee' do
      let!(:visible) { Area.visible(hq_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(6)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root)
        expect(visible).to include(foo_root_child)
        expect(visible).to include(foo_root_child_child)
        expect(visible).to include(bar_root)
        expect(visible).to include(bar_root_child)
        expect(visible).to include(bar_root_child_child)
      end
    end

    context 'as another HQ employee' do
      let!(:visible) { Area.visible(other_hq_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(6)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root)
        expect(visible).to include(foo_root_child)
        expect(visible).to include(foo_root_child_child)
        expect(visible).to include(bar_root)
        expect(visible).to include(bar_root_child)
        expect(visible).to include(bar_root_child_child)
      end
    end

    context 'as an all-field-visible employee' do
      let!(:visible) { Area.visible(all_field_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(6)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root)
        expect(visible).to include(foo_root_child)
        expect(visible).to include(foo_root_child_child)
        expect(visible).to include(bar_root)
        expect(visible).to include(bar_root_child)
        expect(visible).to include(bar_root_child_child)
      end
    end

    context 'as an all-corporate-visible employee' do
      let!(:visible) { Area.visible(all_corporate_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(0)
      end

      it 'excludes everything' do
        expect(visible).not_to include(foo_root)
        expect(visible).not_to include(foo_root_child)
        expect(visible).not_to include(foo_root_child_child)
        expect(visible).not_to include(bar_root)
        expect(visible).not_to include(bar_root_child)
        expect(visible).not_to include(bar_root_child_child)
      end
    end

    context 'as an everything-is-visible employee' do
      let!(:visible) { Area.visible(everything_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(6)
      end

      it 'includes the areas that should be visible' do
        expect(visible).to include(foo_root)
        expect(visible).to include(foo_root_child)
        expect(visible).to include(foo_root_child_child)
        expect(visible).to include(bar_root)
        expect(visible).to include(bar_root_child)
        expect(visible).to include(bar_root_child_child)
      end
    end
  end
end
