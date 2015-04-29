class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end

  def update_own_basic?
    has_permission? 'update_own_basic'
  end

  def terminate?
    return true if @user.managed_team_members.include? @record
    return true if has_permission? 'terminate'
    false
  end

  def approval?
    @user.managed_team_members.any?
  end
end
