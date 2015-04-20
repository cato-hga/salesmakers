class WorkmarketAssignmentPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def view_all?
    has_permission? 'view_all'
  end
end
