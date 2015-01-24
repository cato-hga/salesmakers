require 'rails_helper'

describe DevicePolicy do
  let(:permitted_person) { create :it_tech_person }
  let(:permission_index) { create :permission, key: 'device_index' }
  let(:permission_new) { create :permission, key: 'device_new' }
  let(:permission_create) { create :permission, key: 'device_create' }
  let(:permission_edit) { create :permission, key: 'device_edit' }
  let(:permission_update) { create :permission, key: 'device_update' }
  let(:permission_write_off) { create :permission, key: 'device_write_off' }
  let(:permission_destroy) { create :permission, key: 'device_destroy' }
  let(:permission_add_state) { create :permission, key: 'device_add_state' }
  let(:permission_remove_state) { create :permission, key: 'device_remove_state' }
  let(:permission_csv) { create :permission, key: 'device_csv' }
  let(:permission_lost_stolen) { create :permission, key: 'device_lost_stolen' }
  let(:permission_found) { create :permission, key: 'device_found' }
  let(:permission_repairing) { create :permission, key: 'device_repairing' }
  let(:unpermitted_person) { build_stubbed :person }

  context 'for those with permission' do
    before(:each) do
      permitted_person.position.permissions << permission_index
      permitted_person.position.permissions << permission_new
      permitted_person.position.permissions << permission_create
      permitted_person.position.permissions << permission_edit
      permitted_person.position.permissions << permission_update
      permitted_person.position.permissions << permission_write_off
      permitted_person.position.permissions << permission_destroy
      permitted_person.position.permissions << permission_add_state
      permitted_person.position.permissions << permission_remove_state
      permitted_person.position.permissions << permission_csv
      permitted_person.position.permissions << permission_lost_stolen
      permitted_person.position.permissions << permission_found
      permitted_person.position.permissions << permission_repairing
    end
    let(:policy) { DevicePolicy.new permitted_person, Device.new }
    
    specify { expect(policy.index?).to be_truthy }
    specify { expect(policy.csv?).to be_truthy }
    specify { expect(policy.new?).to be_truthy }
    specify { expect(policy.create?).to be_truthy }
    specify { expect(policy.edit?).to be_truthy }
    specify { expect(policy.update?).to be_truthy }
    specify { expect(policy.destroy?).to be_truthy }
    specify { expect(policy.write_off?).to be_truthy }
    specify { expect(policy.lost_stolen?).to be_truthy }
    specify { expect(policy.found?).to be_truthy }
    specify { expect(policy.add_state?).to be_truthy }
    specify { expect(policy.remove_state?).to be_truthy }
    specify { expect(policy.repairing?).to be_truthy }
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
  end
end