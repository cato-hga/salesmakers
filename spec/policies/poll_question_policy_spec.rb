require 'rails_helper'

describe PollQuestionPolicy do
  let(:person) { create :it_tech_person }
  let(:permission_manage) { create :permission, key: 'poll_question_manage' }

  describe 'management access' do
    let(:permission) { Permission.find_by key: 'poll_question_manage' }

    specify 'should be allowed with permissions' do
      person.position.permissions << permission_manage
      policy = PollQuestionPolicy.new person, PollQuestion.new
      expect(policy.index?).to be_truthy
      expect(policy.new?).to be_truthy
      expect(policy.create?).to be_truthy
      expect(policy.edit?).to be_truthy
      expect(policy.update?).to be_truthy
      expect(policy.destroy?).to be_truthy
    end

    specify 'should not be allowed without permissions' do
      person.position.permissions.destroy_all
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
    let(:permission_show) { create :permission, key: 'poll_question_show' }
    let(:permission) { Permission.find_by key: 'poll_question_show' }

    specify 'should be allowed with permissions' do
      person.position.permissions << permission_show
      policy = PollQuestionPolicy.new person, PollQuestion.new
      expect(policy.show?).to be_truthy
    end

    specify 'should not be allowed without permissions' do
      person.position.permissions.destroy_all
      policy = PollQuestionPolicy.new person, PollQuestion.new
      expect(policy.show?).to be_falsey
    end
  end
end