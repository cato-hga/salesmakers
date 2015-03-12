class InterviewSchedulePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      return scope.none unless person.position
      permission = Permission.find_by key: 'candidate_view_all'
      if permission and person.position.permissions.include? permission
        scope.all
      else
        scope.where(person: person)
      end
    end
  end
end