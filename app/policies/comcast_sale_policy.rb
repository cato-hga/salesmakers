class ComcastSalePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      people = PersonPolicy::Scope.new(self.person, Person).resolve
      if people.empty?
        scope.none
      else
        scope.where('comcast_sales.person_id IN (?)', [people.ids].flatten)
      end
    end
  end

end