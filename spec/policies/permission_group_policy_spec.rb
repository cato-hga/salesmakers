require 'rails_helper'

RSpec.describe PermissionGroupPolicy do

  describe PermissionGroupPolicy do
    subject { PermissionGroupPolicy }

    let(:person) { create :person }
    #let(:position) { create :position }

    permissions :index? do

      it 'should restrict access to persons without permission_group_index permission' do
        expect(subject).not_to permit(person, PermissionGroup.new)
      end

      it 'should allow access to persons with permission_group_index permission' do
        person.position.permissions << create(:permission, key: 'permission_group_index')
        expect(subject).to permit(person, PermissionGroup.new)
      end
    end

    permissions :create? do
      it 'should restrict access to persons without permission_group_create permission' do
        expect(subject).not_to permit(person, PermissionGroup.new)
      end

      it 'should allow access to persons with permission_group_create permission' do
        person.position.permissions << create(:permission, key: 'permission_group_create')
        expect(subject).to permit(person, PermissionGroup.new)
      end
    end

    permissions :update? do
      it 'should restrict access to persons without permission_group_update permission' do
        expect(subject).not_to permit(person, PermissionGroup.new)
      end

      it 'should allow access to persons with permission_group_update permission' do
        person.position.permissions << create(:permission, key: 'permission_group_update')
        expect(subject).to permit(person, PermissionGroup.new)
      end
    end
    permissions :destroy? do
      it 'should restrict access to persons without permission_group_destroy permission' do
        expect(subject).not_to permit(person, PermissionGroup.new)
      end

      it 'should allow access to persons with permission_group_destroy permission' do
        person.position.permissions << create(:permission, key: 'permission_group_destroy')
        expect(subject).to permit(person, PermissionGroup.new)
      end
    end

    permissions :show? do
      it 'should restrict access to persons without permission_group_destroy permission' do
        expect(subject).not_to permit(person, create(:permission_group))
      end

      it 'should allow access to persons with permission_group_destroy permission' do
        person.position.permissions << create(:permission, key: 'permission_group_index')
        expect(subject).to permit(person, create(:permission_group))
      end
    end
  end
end