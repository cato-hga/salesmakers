class ProfilePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end

  def update?
    return false unless has_permission? 'update'
    return true if @record.person and @record.person == @user
    has_permission? 'update_others'
  end

end
