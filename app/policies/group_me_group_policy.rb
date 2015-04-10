class GroupMeGroupPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      return scope.none unless has_position?
      return scope.all if has_all_visibility?
      management_person_areas = self.person.person_areas.where(manages: true)
      return scope.none if management_person_areas.empty?
      areas = management_person_areas.
          map{ |pa| pa.area.subtree.ids }.
          flatten
      scope.where('group_me_groups.area_id IN (?)', areas.flatten.uniq)
    end

    private

    def has_position?
      self.person and self.person.position
    end

    def has_all_visibility?
      self.person.position.hq? and
          self.person.position.all_field_visibility?
    end
  end

  def new_post?
    post?
  end

  def post?
    has_permission?('post')
  end
end
