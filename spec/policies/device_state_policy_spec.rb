describe DeviceStatePolicy do
  let(:permitted_person) { create :it_tech_person }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'device_state_index', permission_group: permission_group, description: description }
  let(:permission_new) { Permission.new key: 'device_state_new', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'device_state_create', permission_group: permission_group, description: description }
  let(:permission_edit) { Permission.new key: 'device_state_edit', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'device_state_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'device_state_destroy', permission_group: permission_group, description: description }
  let(:unpermitted_person) { build_stubbed :person }
  context 'for those with permission' do
    before(:each) do
      permitted_person.position.permissions << permission_index
      permitted_person.position.permissions << permission_new
      permitted_person.position.permissions << permission_create
      permitted_person.position.permissions << permission_edit
      permitted_person.position.permissions << permission_update
      permitted_person.position.permissions << permission_destroy
    end
    let(:policy) { DeviceStatePolicy.new permitted_person, DeviceState.new }
    specify { expect(policy.index?).to be_truthy }
    specify { expect(policy.new?).to be_truthy }
    specify { expect(policy.create?).to be_truthy }
    specify { expect(policy.edit?).to be_truthy }
    specify { expect(policy.update?).to be_truthy }
    specify { expect(policy.destroy?).to be_truthy }
  end

  context 'for those without permission' do
    let(:policy) { DeviceStatePolicy.new unpermitted_person, DeviceState.new }
    specify { expect(policy.index?).to be_falsey }
    specify { expect(policy.new?).to be_falsey }
    specify { expect(policy.create?).to be_falsey }
    specify { expect(policy.edit?).to be_falsey }
    specify { expect(policy.update?).to be_falsey }
    specify { expect(policy.destroy?).to be_falsey }
  end
end