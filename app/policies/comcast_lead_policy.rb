class ComcastLeadPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      customers = ComcastCustomerPolicy::Scope.new(self.person, ComcastCustomer).resolve
      scope.where(comcast_customer: customers)
    end
  end
end