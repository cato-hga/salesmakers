class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end

  def update_own_basic?
    has_permission? 'update_own_basic'
  end

  def terminate?
    has_permission? 'terminate'
  end

  def send_nos?
    has_permission? 'terminate'
  end
end
