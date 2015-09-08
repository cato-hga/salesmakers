class GiftCardOverridePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def new_override?
    new?
  end

  def create_override?
    new_override?
  end
end