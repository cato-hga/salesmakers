require 'rails_helper'

describe DeviceStatePolicy do
  let(:permitted_person) { Person.first }
  let(:unpermitted_person) { build_stubbed :person }

  context 'for those with permission' do
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