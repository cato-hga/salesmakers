class WallPostPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def destroy?(visible_people = nil)
    visible_people = Person.visible(user) unless visible_people
    visible_people.include?(record.publication.publishable.person)
  end

  def promote?
    has_permission? 'promote'
  end
end
