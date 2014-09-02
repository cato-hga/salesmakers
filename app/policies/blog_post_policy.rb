class BlogPostPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end
end
