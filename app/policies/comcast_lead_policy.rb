class ComcastLeadPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      customers = ComcastCustomerPolicy::Scope.new(self.person, ComcastCustomer).resolve
      if customers.empty?
        scope.none
      else
        scope.where('comcast_leads.comcast_customer_id IN (?)', [customers.ids].flatten)
      end
    end
  end
end