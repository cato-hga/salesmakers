class WorkmarketAssignmentPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def show?
    has_permission? 'show'
  end

  def view_all?
    has_permission? 'view_all'
  end

  def csv?
    index?
  end
end
