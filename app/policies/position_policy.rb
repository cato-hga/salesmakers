class PositionPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end
end
