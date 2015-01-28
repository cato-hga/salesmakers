require 'rails_helper'

describe LinePolicy do
  let(:permitted_person) { create :it_tech_person }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'line_index', permission_group: permission_group, description: description }
  let(:permission_new) { Permission.new key: 'line_new', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'line_create', permission_group: permission_group, description: description }
  let(:permission_edit) { Permission.new key: 'line_edit', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'line_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'line_destroy', permission_group: permission_group, description: description }
  let(:permission_deactivate) { Permission.new key: 'line_deactivate', permission_group: permission_group, description: description }
  let(:permission_add_state) { Permission.new key: 'line_add_state', permission_group: permission_group, description: description }
  let(:permission_remove_state) { Permission.new key: 'line_remove_state', permission_group: permission_group, description: description }
  let(:unpermitted_person) { build_stubbed :person }
  context 'for those with permission' do
    let(:policy) { LinePolicy.new permitted_person, Line.new }

    specify {
      permitted_person.position.permissions << permission_index
      expect(policy.index?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_create
      expect(policy.new?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_create
      expect(policy.create?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.edit?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.update?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.deactivate?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_destroy
      expect(policy.destroy?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.add_state?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.remove_state?).to be_truthy }
  end

  context 'for those without permission' do
    let(:policy) { LinePolicy.new unpermitted_person, Line.new }

    specify { expect(policy.index?).to be_falsey }
    specify { expect(policy.new?).to be_falsey }
    specify { expect(policy.create?).to be_falsey }
    specify { expect(policy.edit?).to be_falsey }
    specify { expect(policy.update?).to be_falsey }
    specify { expect(policy.deactivate?).to be_falsey }
    specify { expect(policy.destroy?).to be_falsey }
    specify { expect(policy.add_state?).to be_falsey }
    specify { expect(policy.remove_state?).to be_falsey }
  end

end