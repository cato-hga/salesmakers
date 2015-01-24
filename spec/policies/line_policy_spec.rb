require 'rails_helper'

describe LinePolicy do
  let(:permitted_person) { create :it_tech_person }
  let(:permission_index) { create :permission, key: 'line_index' }
  let(:permission_new) { create :permission, key: 'line_new' }
  let(:permission_create) { create :permission, key: 'line_create' }
  let(:permission_edit) { create :permission, key: 'line_edit' }
  let(:permission_update) { create :permission, key: 'line_update' }
  let(:permission_deactivate) { create :permission, key: 'line_deactivate' }
  let(:permission_destroy) { create :permission, key: 'line_destroy' }
  let(:permission_add_state) { create :permission, key: 'line_add_state' }
  let(:permission_remove_state) { create :permission, key: 'line_remove_state' }
  let(:unpermitted_person) { build_stubbed :person }

  context 'for those with permission' do
    before(:each) do
      permitted_person.position.permissions << permission_index
      permitted_person.position.permissions << permission_new
      permitted_person.position.permissions << permission_create
      permitted_person.position.permissions << permission_edit
      permitted_person.position.permissions << permission_update
      permitted_person.position.permissions << permission_deactivate
      permitted_person.position.permissions << permission_destroy
      permitted_person.position.permissions << permission_add_state
      permitted_person.position.permissions << permission_remove_state
    end
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