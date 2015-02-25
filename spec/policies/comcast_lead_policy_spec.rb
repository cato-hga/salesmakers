require 'rails_helper'

describe ComcastLeadPolicy do
  let(:department_one) { create :department, name: 'Department One' }
  let(:department_two) { create :department, name: 'Department Two' }
  let(:position_one) { create :position, department: department_one }
  let(:position_two) { create :position, department: department_two }
  let(:permitted_person) { create :comcast_employee, position: position_one }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'comcast_lead_index', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'comcast_lead_create', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'comcast_lead_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'comcast_lead_destroy', permission_group: permission_group, description: description }
  let(:unpermitted_person) { create :person, position: position_two }

  context 'for those with permission' do
    before(:each) do
      permitted_person.position.permissions << permission_index
      permitted_person.position.permissions << permission_create
      permitted_person.position.permissions << permission_update
      permitted_person.position.permissions << permission_destroy
    end
    let(:policy) { described_class.new permitted_person, ComcastLead.new }

    specify { expect(policy.index?).to be_truthy }
    specify { expect(policy.new?).to be_truthy }
    specify { expect(policy.create?).to be_truthy }
    specify { expect(policy.edit?).to be_truthy }
    specify { expect(policy.update?).to be_truthy }
    specify { expect(policy.destroy?).to be_truthy }
  end

  context 'for those without permission' do
    let(:policy) { described_class.new unpermitted_person, ComcastLead.new }

    specify { expect(policy.index?).to be_falsey }
    specify { expect(policy.new?).to be_falsey }
    specify { expect(policy.create?).to be_falsey }
    specify { expect(policy.edit?).to be_falsey }
    specify { expect(policy.update?).to be_falsey }
    specify { expect(policy.destroy?).to be_falsey }
  end

  describe 'scope' do
    let(:permitted_comcast_customer) { create :comcast_customer, person: permitted_person }
    let!(:permitted_comcast_lead) { create :comcast_lead, comcast_customer: permitted_comcast_customer }
    let(:unpermitted_comcast_customer) { create :comcast_customer, person: unpermitted_person }
    let!(:unpermitted_comcast_lead) { create :comcast_lead, comcast_customer: unpermitted_comcast_customer }
    let(:area) { create :area }
    let!(:person_area) { create :person_area, person: permitted_person, area: area }

    let(:records) { ComcastLeadPolicy::Scope.new(permitted_person, ComcastLead).resolve }

    it 'shows leads for permitted people' do
      expect(records).to include(permitted_comcast_lead)
    end

    it 'hides leads for unpermitted people' do
      expect(records).not_to include(unpermitted_comcast_lead)
    end
  end
end
