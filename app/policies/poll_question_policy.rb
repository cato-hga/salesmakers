class PollQuestionPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def manage?
    has_permission? 'manage'
  end

  def index?
    manage?
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

  def show?
    has_permission? 'show'
  end
end
