class PositionPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def edit_permissions?
    edit?
  end

  def update_permissions?
    edit_permissions?
  end
end
