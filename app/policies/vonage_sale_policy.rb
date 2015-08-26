class VonageSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    include CustomerAndSaleScope

    def table_name
      'vonage_sales'
    end
  end

  def csv?
    index?
  end
end
