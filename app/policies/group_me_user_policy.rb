class GroupMeUserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
