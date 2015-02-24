module PersonToPersonVisibilityModelExtension
  def self.included(klass)
    klass.extend ClassMethods
  end

  def managed_team_members
    people = Array.new
    for person_area in self.person_areas do
      next unless person_area.area
      next unless person_area.manages
      areas = person_area.area.subtree
      for area in areas do
        people = people.concat area.people.to_a
      end
    end
    people.flatten
  end

  def team_members
    people = Array.new
    for person_area in self.person_areas do
      next unless person_area.area
      areas = person_area.area.subtree
      for area in areas do
        people = people.concat area.people.to_a
      end
    end
    people.flatten
  end

  def department_members
    return Person.none unless self.department
    self.department.people
  end

  module ClassMethods
    def visible(person = nil)
      return Person.none unless person
      people = Array.new
      position = person.position
      return person.team_members unless position
      if position.all_field_visibility?
        people = people.concat Person.all_field_members
      end
      if position.all_corporate_visibility?
        people = people.concat Person.all_hq_members
      end
      if position.hq?
        people = people.concat person.department_members
      end

      people = people.concat person.team_members
      return Person.none if people.count < 1

      Person.where("\"people\".\"id\" IN (#{people.map(&:id).join(',')})")
    end

    def all_field_members
      positions = Position.where(field: true)
      Person.where(position: positions)
    end

    def all_hq_members
      positions = Position.where(hq: true)
      Person.where(position: positions)
    end
  end
end