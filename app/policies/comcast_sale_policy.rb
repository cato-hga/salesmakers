class ComcastSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      if self.person.manager_or_hq?
        people = PersonPolicy::Scope.new(self.person, Person).resolve
      else
        people = Person.where(id: self.person.id)
      end
      if people.empty?
        scope.none
      else
        scope.where('comcast_sales.person_id IN (?)', [people.ids].flatten)
      end
    end
  end

end