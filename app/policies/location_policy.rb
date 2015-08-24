class LocationPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.all
    end
  end

  def csv?
    index?
  end

  def edit_head_counts?
    has_permission? 'update'
  end

  def update_head_counts?
    edit_head_counts?
  end
end