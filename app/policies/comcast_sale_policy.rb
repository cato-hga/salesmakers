class ComcastSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    include ComcastCustomerAndSaleScope

    def table_name
      'comcast_sales'
    end
  end

end