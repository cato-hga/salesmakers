class DirecTVSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    include DirecTVCustomerAndSaleScope

    def table_name
      'directv_sales'
    end
  end

end