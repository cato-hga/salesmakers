require 'rails_helper'

describe PollQuestionPolicy do
  let(:person) { Person.first }
  let(:position) { person.position }
  let(:permission_group) { PermissionGroup.first }

  describe 'management access' do
    let(:permission) { Permission.find_by key: 'poll_question_manage' }

    specify 'should be allowed with permissions' do
      policy = PollQuestionPolicy.new person, PollQuestion.new
      expect(policy.index?).to be_truthy
      expect(policy.new?).to be_truthy
      expect(policy.create?).to be_truthy
      expect(policy.edit?).to be_truthy
      expect(policy.update?).to be_truthy
      expect(policy.destroy?).to be_truthy
    end

    specify 'should not be allowed without permissions' do
      position.permissions.destroy_all
      policy = PollQuestionPolicy.new person, PollQuestion.new
      expect(policy.index?).to be_falsey
      expect(policy.new?).to be_falsey
      expect(policy.create?).to be_falsey
      expect(policy.edit?).to be_falsey
      expect(policy.update?).to be_falsey
      expect(policy.destroy?).to be_falsey
    end
  end

  describe 'results access' do
    let(:permission) { Permission.find_by key: 'poll_question_show' }

    specify 'should be allowed with permissions' do
      policy = PollQuestionPolicy.new person, PollQuestion.new
      expect(policy.show?).to be_truthy
    end

    specify 'should not be allowed without permissions' do
      position.permissions.destroy_all
      policy = PollQuestionPolicy.new person, PollQuestion.new
      expect(policy.show?).to be_falsey
    end
  end
end