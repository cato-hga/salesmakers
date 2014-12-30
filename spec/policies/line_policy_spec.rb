require 'rails_helper'

describe LinePolicy do
  let(:permitted_person) { Person.first }
  let(:unpermitted_person) { build_stubbed :person }

  context 'for those with permission' do
    let(:policy) { LinePolicy.new permitted_person, Line.new }

    specify { expect(policy.index?).to be_truthy }
    specify { expect(policy.new?).to be_truthy }
    specify { expect(policy.create?).to be_truthy }
    specify { expect(policy.edit?).to be_truthy }
    specify { expect(policy.update?).to be_truthy }
    specify { expect(policy.deactivate?).to be_truthy }
    specify { expect(policy.destroy?).to be_truthy }
    specify { expect(policy.add_state?).to be_truthy }
    specify { expect(policy.remove_state?).to be_truthy }
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