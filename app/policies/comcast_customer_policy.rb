class ComcastCustomerPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      people = PersonPolicy::Scope.new(self.person, Person).resolve
      if people.empty?
        scope.none
      else
        scope.where('comcast_customers.person_id IN (?)', [people.ids].flatten)
      end
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

end
