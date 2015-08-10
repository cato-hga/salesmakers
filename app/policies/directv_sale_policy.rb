class DirecTVSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    include CustomerAndSaleScope

    def table_name
      'directv_sales'
    end
  end

end