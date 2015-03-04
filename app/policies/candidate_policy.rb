class CandidatePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def time_slots?
    create?
  end

  def schedule?
    create?
  end
end