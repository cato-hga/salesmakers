require 'rails_helper'

describe ComcastInstallAppointmentPolicy do
  let(:permitted_person) { create :comcast_employee }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'comcast_install_appointment_index', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'comcast_install_appointment_create', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'comcast_install_appointment_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'comcast_install_appointment_destroy', permission_group: permission_group, description: description }
  let(:unpermitted_person) { build_stubbed :person }

  context 'for those with permission' do
    before(:each) do
      permitted_person.position.permissions << permission_index
      permitted_person.position.permissions << permission_create
      permitted_person.position.permissions << permission_update
      permitted_person.position.permissions << permission_destroy
    end
    let(:policy) { ComcastInstallAppointmentPolicy.new permitted_person, ComcastInstallAppointment.new }

    specify { expect(policy.index?).to be_truthy }
    specify { expect(policy.new?).to be_truthy }
    specify { expect(policy.create?).to be_truthy }
    specify { expect(policy.edit?).to be_truthy }
    specify { expect(policy.update?).to be_truthy }
    specify { expect(policy.destroy?).to be_truthy }
  end

  context 'for those without permission' do
    let(:policy) { ComcastInstallAppointmentPolicy.new unpermitted_person, ComcastInstallAppointment.new }

    specify { expect(policy.index?).to be_falsey }
    specify { expect(policy.new?).to be_falsey }
    specify { expect(policy.create?).to be_falsey }
    specify { expect(policy.edit?).to be_falsey }
    specify { expect(policy.update?).to be_falsey }
    specify { expect(policy.destroy?).to be_falsey }
  end
end
