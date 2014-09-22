class WallPostCommentPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def destroy?
    Person.visible(user).include?(record.wall_post.publication.publishable.person)
  end

end
