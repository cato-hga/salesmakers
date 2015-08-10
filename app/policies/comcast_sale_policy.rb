class ComcastSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    include CustomerAndSaleScope

    def table_name
      'comcast_sales'
    end
  end

end