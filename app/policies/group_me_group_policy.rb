class GroupMeGroupPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      if self.person.position.hq? and self.person.position.all_field_visibility?
        return scope.all
      end
      management_person_areas = self.person.person_areas.where(manages: true)
      return scope.none if management_person_areas.empty?
      areas = management_person_areas.
          map{ |pa| pa.area.subtree.ids }.
          flatten
      scope.where('group_me_groups.area_id IN (?)', areas.flatten.uniq)
    end
  end

  def new_post?
    post?
  end

  def post?
    has_permission?('post')
  end
end
