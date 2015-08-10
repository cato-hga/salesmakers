class LocationPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.all
    end
  end

  def csv?
    index?
  end
end