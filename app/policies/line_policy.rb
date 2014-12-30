class LinePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def deactivate?
    update?
  end

  def add_state?
    update?
  end

  def remove_state?
    update?
  end
end