class DirecTVLeadPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      customers = DirecTVCustomerPolicy::Scope.new(self.person, DirecTVCustomer).resolve
      if customers.empty?
        scope.none
      else
        scope.where('directv_leads.directv_customer_id IN (?)', [customers.ids].flatten)
      end
    end
  end
end