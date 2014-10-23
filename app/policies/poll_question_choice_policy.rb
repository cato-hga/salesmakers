class PollQuestionChoicePolicy < ApplicationPolicy
  def manage?
    PollQuestionPolicy.new(@user, @record).manage?
  end

  def create?
    manage?
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end
end
