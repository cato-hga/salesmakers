class PermissionGroupPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      policy = PermissionGroupPolicy.new person, PermissionGroup.new
      if policy.index?
        scope.all
      else
        PermissionGroup.where('false')
      end
    end
  end

end
