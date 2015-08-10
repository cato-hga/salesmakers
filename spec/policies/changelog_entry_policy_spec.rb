require 'rails_helper'

describe ChangelogEntryPolicy do
  let(:person) { create :it_tech_person }
  let(:permission_manage) { create :permission, key: 'changelog_entry_manage' }

  describe 'management access' do
    let(:permission) { Permission.find_by key: 'changelog_entry_manage' }

    specify 'should be allowed with permissions' do
      person.position.permissions << permission_manage
      policy = ChangelogEntryPolicy.new person, ChangelogEntry.new
      expect(policy.index?).to be_truthy
      expect(policy.new?).to be_truthy
      expect(policy.create?).to be_truthy
      expect(policy.edit?).to be_truthy
      expect(policy.update?).to be_truthy
      expect(policy.destroy?).to be_truthy
    end

    specify 'should not be allowed without permissions' do
      person.position.permissions.destroy_all
      policy = ChangelogEntryPolicy.new person, ChangelogEntry.new
      expect(policy.index?).to be_falsey
      expect(policy.new?).to be_falsey
      expect(policy.create?).to be_falsey
      expect(policy.edit?).to be_falsey
      expect(policy.update?).to be_falsey
      expect(policy.destroy?).to be_falsey
    end
  end
end