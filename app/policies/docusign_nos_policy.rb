class DocusignNosPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end

  def new?
    terminate = Permission.find_by key: 'person_terminate'
    return true if @user.position.permissions.include?(terminate)
    false
  end

  def create?
    terminate = Permission.find_by key: 'person_terminate'
    return true if @user.position.permissions.include?(terminate)
    false
  end
end
