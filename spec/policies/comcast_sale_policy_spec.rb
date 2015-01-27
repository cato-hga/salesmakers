require 'rails_helper'

describe ComcastSalePolicy do
  let(:permitted_person) { create :comcast_employee }
  let(:permission_index) { create :permission, key: 'comcast_sale_index' }
  let(:permission_create) { create :permission, key: 'comcast_sale_create' }
  let(:permission_update) { create :permission, key: 'comcast_sale_update' }
  let(:permission_destroy) { create :permission, key: 'comcast_sale_destroy' }
  let(:unpermitted_person) { build_stubbed :person }

  context 'for those with permission' do
    before(:each) do
      permitted_person.position.permissions << permission_index
      permitted_person.position.permissions << permission_create
      permitted_person.position.permissions << permission_update
      permitted_person.position.permissions << permission_destroy
    end
    let(:policy) { ComcastSalePolicy.new permitted_person, ComcastSale.new }

    specify { expect(policy.index?).to be_truthy }
    specify { expect(policy.new?).to be_truthy }
    specify { expect(policy.create?).to be_truthy }
    specify { expect(policy.edit?).to be_truthy }
    specify { expect(policy.update?).to be_truthy }
    specify { expect(policy.destroy?).to be_truthy }
  end

  context 'for those without permission' do
    let(:policy) { ComcastSalePolicy.new unpermitted_person, ComcastSale.new }

    specify { expect(policy.index?).to be_falsey }
    specify { expect(policy.new?).to be_falsey }
    specify { expect(policy.create?).to be_falsey }
    specify { expect(policy.edit?).to be_falsey }
    specify { expect(policy.update?).to be_falsey }
    specify { expect(policy.destroy?).to be_falsey }
  end
end
