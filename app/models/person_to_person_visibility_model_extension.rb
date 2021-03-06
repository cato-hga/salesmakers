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
        people = people.concat area.people.where(active: true).order(:display_name).to_a
      end
    end
    people.flatten
  end

  def managed_managers
    managers = []
    for person_area in self.person_areas do
      next unless person_area.area
      next unless person_area.manages
      areas = person_area.area.descendants
      for area in areas do
        managers = managers.concat Person.
                                       joins(:person_areas).
                                       where("person_areas.area_id = ? AND person_areas.manages = true AND people.active = true",
                                             area.id)
      end
    end
    managers.flatten.compact
  end

  def directly_managed_team_members
    people = Array.new
    for person_area in self.person_areas do
      next unless person_area.area
      next unless person_area.manages
      areas = person_area.area.subtree
      for area in areas do
        managers = area.direct_managers
        next unless managers.include?(self)
        people = people.concat area.people.where(active: true).order(:display_name).to_a
      end
    end
    people.flatten
  end

  def team_members
    people_ids = Array.new
    for person_area in self.person_areas do
      next unless person_area.area
      areas = person_area.area.subtree
      for area in areas do
        people_ids = people_ids.concat area.people.ids
      end
    end
    Person.where id: people_ids
  end

  def department_members
    return Person.none unless self.department
    self.department.people
  end

  def direct_supervisors
    manager_ids = []
    self.person_areas.each do |pa|
      parent_area = pa.area
      manager_person_areas = parent_area.person_areas.joins(:person).where("person_areas.manages = true AND people.active = true")
      while manager_person_areas.empty? && parent_area.parent
        parent_area = parent_area.parent
        manager_person_areas = parent_area.person_areas.joins(:person).where("person_areas.manages = true AND people.active = true")
      end
      manager_ids.concat manager_person_areas.map { |mpa| mpa.person.id } unless manager_person_areas.empty?
    end
    Person.where(id: manager_ids)
  end

  module ClassMethods
    def visible(person = nil)
      return Person.none unless person
      people_ids = Array.new
      position = person.position
      return person.team_members unless position
      if position.all_field_visibility?
        people_ids = people_ids.concat Person.unscoped.all_field_members.ids
      end
      if position.all_corporate_visibility?
        people_ids = people_ids.concat Person.unscoped.all_hq_members.ids
      end
      if position.hq?
        people_ids = people_ids.concat person.department_members.ids
      end

      people_ids = people_ids.concat person.team_members.ids
      people_ids = people_ids.uniq
      return Person.none if people_ids.count < 1

      Person.where(id: people_ids)
    end

    def all_field_members
      position_ids = Position.unscoped.where(field: true).ids
      Person.where(position_id: position_ids)
    end

    def all_hq_members
      position_ids = Position.unscoped.where(hq: true).ids
      Person.where(position_id: position_ids)
    end
  end
end