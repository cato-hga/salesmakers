class CandidatePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def show?
    index?
  end

  def time_slots?
    create?
  end

  def schedule?
    create?
  end

  def select_location?
    create?
  end

  def set_location?
    select_location?
  end
end