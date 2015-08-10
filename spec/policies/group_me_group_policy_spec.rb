require 'rails_helper'

describe GroupMeGroupPolicy do
  let(:area) { create :area }
  let(:department_one) { create :department, name: 'Department One' }
  let(:department_two) { create :department, name: 'Department Two' }
  let(:position_one) { create :position, department: department_one }
  let(:position_two) { create :position, department: department_two }
  let(:permitted_person) { create :comcast_employee, position: position_one }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_post) { Permission.new key: 'group_me_group_post', permission_group: permission_group, description: description }
  let(:unpermitted_person) { create :person, position: position_two }
  let!(:permitted_person_area) {
    create :person_area,
           person: permitted_person,
           area: area,
           manages: true
  }

  context 'for those with permission' do
    before(:each) do
      permitted_person.position.permissions << permission_post
    end
    let(:policy) { described_class.new permitted_person, GroupMeGroup.new }

    specify { expect(policy.post?).to be_truthy }
  end

  context 'for those without permission' do
    let(:policy) { described_class.new unpermitted_person, GroupMeGroup.new }

    specify { expect(policy.post?).to be_falsey }
  end

  describe 'scope' do
    let!(:permitted_group_me_group) {
      create :group_me_group,
             area: area
    }
    let!(:unpermitted_group_me_group) {
      create :group_me_group
    }
    let(:hq_position) {
      Position.create name: 'HQ Position',
                      department: department_one,
                      hq: true,
                      field: false,
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: false
    }

    let(:records) {
      GroupMeGroupPolicy::Scope.new(permitted_person, GroupMeGroup.all).resolve
    }

    it 'shows leads for permitted people' do
      expect(records).to include(permitted_group_me_group)
    end

    it 'hides leads for unpermitted people' do
      expect(records).not_to include(unpermitted_group_me_group)
    end

    it 'shows all groups for HQ employees with all_field_visibility' do
      permitted_person.update position: hq_position
      expect(records.count).to eq(2)
    end

    it 'does not show all groups for HQ employees without all_field_visibility' do
      hq_position.update all_field_visibility: false
      permitted_person.update position: hq_position
      expect(records.count).to eq(1)
    end
  end

end
