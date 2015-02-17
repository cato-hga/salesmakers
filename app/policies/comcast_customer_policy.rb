class ComcastCustomerPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.all
    end
  end

  def update?
    ComcastCustomer.manageable(@user).include?(@record)
  end

  def destroy?
    update?
  end

end
