module DirecTVCustomerAndSaleScope
  def resolve
    if self.person.manager_or_hq?
      people = PersonPolicy::Scope.new(self.person, Person).resolve
    else
      people = Person.where(id: self.person.id)
    end
    if people.empty?
      scope.none
    else
      scope.where("#{table_name}.person_id IN (?)", [people.ids].flatten)
    end
  end
end