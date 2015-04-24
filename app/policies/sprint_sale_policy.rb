class SprintSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def scoreboard?
    index?
  end
end
