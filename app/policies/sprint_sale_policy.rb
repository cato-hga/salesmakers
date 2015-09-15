class SprintSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    include CustomerAndSaleScope

    def table_name
      'sprint_sales'
    end
  end

  def scoreboard?
    index?
  end

  def csv?
    index?
  end

  def show?
    index?
  end
end
