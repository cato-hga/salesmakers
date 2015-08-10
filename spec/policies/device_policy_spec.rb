require 'rails_helper'

describe DevicePolicy do
  let(:permitted_person) { create :it_tech_person }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'device_index', permission_group: permission_group, description: description }
  let(:permission_new) { Permission.new key: 'device_new', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'device_create', permission_group: permission_group, description: description }
  let(:permission_edit) { Permission.new key: 'device_edit', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'device_update', permission_group: permission_group, description: description }
  let(:permission_write_off) { Permission.new key: 'device_write_off', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'device_destroy', permission_group: permission_group, description: description }
  let(:permission_add_state) { Permission.new key: 'device_add_state', permission_group: permission_group, description: description }
  let(:permission_remove_state) { Permission.new key: 'device_remove_state', permission_group: permission_group, description: description }
  let(:permission_csv) { Permission.new key: 'device_csv', permission_group: permission_group, description: description }
  let(:permission_lost_stolen) { Permission.new key: 'device_lost_stolen', permission_group: permission_group, description: description }
  let(:permission_found) { Permission.new key: 'device_found', permission_group: permission_group, description: description }
  let(:permission_repairing) { Permission.new key: 'device_repairing', permission_group: permission_group, description: description }
  let(:permission_repaired) { Permission.new key: 'device_repaired', permission_group: permission_group, description: description }
  let(:unpermitted_person) { build_stubbed :person }


  context 'for those with permission' do
    let(:policy) { DevicePolicy.new permitted_person, Device.new }

    specify {
      permitted_person.position.permissions << permission_index
      expect(policy.index?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_index
      expect(policy.csv?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_create
      expect(policy.new?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_create
      expect(policy.create?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.edit?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.update?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_destroy
      expect(policy.destroy?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.write_off?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.lost_stolen?).to be_truthy
    }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.found?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.add_state?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.remove_state?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.repairing?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.repaired?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.line_swap_or_move?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.line_swap_results?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.line_swap_finalize?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.line_move_results?).to be_truthy }
    specify {
      permitted_person.position.permissions << permission_update
      expect(policy.line_move_finalize?).to be_truthy }
  end

  context 'for those without permission' do
    let(:policy) { DevicePolicy.new unpermitted_person, Device.new }

    specify { expect(policy.index?).to be_falsey }
    specify { expect(policy.csv?).to be_falsey }
    specify { expect(policy.new?).to be_falsey }
    specify { expect(policy.create?).to be_falsey }
    specify { expect(policy.edit?).to be_falsey }
    specify { expect(policy.update?).to be_falsey }
    specify { expect(policy.destroy?).to be_falsey }
    specify { expect(policy.write_off?).to be_falsey }
    specify { expect(policy.lost_stolen?).to be_falsey }
    specify { expect(policy.found?).to be_falsey }
    specify { expect(policy.add_state?).to be_falsey }
    specify { expect(policy.remove_state?).to be_falsey }
    specify { expect(policy.repairing?).to be_falsey }
    specify { expect(policy.repaired?).to be_falsey }
    specify { expect(policy.line_swap_or_move?).to be_falsey }
    specify { expect(policy.line_swap_results?).to be_falsey }
    specify { expect(policy.line_swap_finalize?).to be_falsey }
    specify { expect(policy.line_move_results?).to be_falsey }
    specify { expect(policy.line_move_finalize?).to be_falsey }
  end
end