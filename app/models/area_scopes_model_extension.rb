module AreaScopesModelExtension
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def visible(person = nil, return_self_area = false)
      return Area.none unless person
      return Area.all if person.position and
          (person.position.hq? or person.position.all_field_visibility?)
      areas = get_management_areas(person)
      if areas.count < 1 and return_self_area
        areas = person.person_areas.map {|pa| pa.area }
      elsif areas.count < 1
        return Area.none
      end
      Area.where("areas.id IN (#{areas.map(&:id).join(',')})")
    end

    def get_management_areas(person = nil)
      return [] unless person
      areas = []
      person_areas = person.person_areas
      for person_area in person_areas do
        if person_area.manages?
          areas = areas.concat person_area.area.subtree.to_a
        else
          areas << person_area.area
        end
      end
      areas.flatten.compact
    end

    def project_roots(project = nil)
      return Area.none unless project
      Area.roots.where(project: project).order(:name)
    end
  end
end
