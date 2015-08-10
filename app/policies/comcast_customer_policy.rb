class ComcastCustomerPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    include CustomerAndSaleScope

    def table_name
      'comcast_customers'
    end
  end

  def show?
    index?
  end

  def update?
    ComcastCustomer.manageable(@user).include?(@record)
  end

  def destroy?
    update?
  end

  def reassign?
    ComcastCustomer.manageable(@user).include?(@record)
  end

  def reassign_to?
    reassign?
  end

  def dismiss?
    update?
  end
end
