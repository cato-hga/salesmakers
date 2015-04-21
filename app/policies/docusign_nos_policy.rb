class DocusignNosPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end

  def new?
    has_permission? 'terminate'
  end

  def create?
    has_permission? 'terminate'
  end
end
