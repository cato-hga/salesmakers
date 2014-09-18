class WallPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end

  def show_all_walls?
    has_permission? 'show_all_walls'
  end
end
