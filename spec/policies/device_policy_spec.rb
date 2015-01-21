require 'rails_helper'

describe DevicePolicy do
  let(:permitted_person) { Person.first }
  let(:unpermitted_person) { build_stubbed :person }
  
  context 'for those with permission' do
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