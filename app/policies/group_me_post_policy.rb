class GroupMePostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
