class WallPostPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def destroy?
    Person.visible(user).include?(record.publication.publishable.person)
  end
end
