class AreaPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end

  def management_scorecard?
    has_permission? 'management_scorecard'
  end
end
