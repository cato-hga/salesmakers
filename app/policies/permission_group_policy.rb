class PermissionGroupPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def index?
    return false unless @user and @user.position
    permission = Permission.find_by key: 'permission_group_index'
    return @user.position.permissions.include? permission
  end

end
