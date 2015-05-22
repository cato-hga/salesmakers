class DirecTVCustomerPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    include CustomerAndSaleScope

    def table_name
      'directv_customers'
    end
  end

  def show?
    index?
  end

  def update?
    DirecTVCustomer.manageable(@user).include?(@record)
  end

  def destroy?
    update?
  end

end
