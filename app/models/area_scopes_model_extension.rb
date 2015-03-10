module AreaScopesModelExtension
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def visible(person = nil)
      return Area.none unless person
      return Area.all if person.position and
          (person.position.hq? or person.position.all_field_visibility?)
      areas = Array.new
      person_areas = person.person_areas
      for person_area in person_areas do
        if person_area.manages?
          areas = areas.concat person_area.area.subtree.to_a
        else
          areas << person_area.area
        end
      end

      return Area.none if areas.count < 1

      Area.where("areas.id IN (#{areas.map(&:id).join(',')})")
    end

    def project_roots(project = nil)
      return Area.none unless project
      Area.roots.where(project: project).order(:name)
    end
  end
end
