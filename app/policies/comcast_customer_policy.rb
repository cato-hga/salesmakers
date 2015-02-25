class ComcastCustomerPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      people = PersonPolicy::Scope.new(self.person, Person).resolve
      scope.where(person: people)
    end
  end

  def update?
    ComcastCustomer.manageable(@user).include?(@record)
  end

  def destroy?
    update?
  end

end
