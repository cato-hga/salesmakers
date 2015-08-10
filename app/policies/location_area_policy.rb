class LocationAreaPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      outsourced = LocationAreaPolicy.new(person, LocationArea.new).outsourced?
      if outsourced
        scope
      else
        scope.where "outsourced = false"
      end
    end
  end

  def outsourced?
    has_permission? 'outsourced'
  end

  def index?
    LocationPolicy.new(user, Location.new).index?
  end
end