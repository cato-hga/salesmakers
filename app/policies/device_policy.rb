class DevicePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
    end
  end

  def csv?
    index?
  end

  def write_off?
    update?
  end

  def lost_stolen?
    update?
  end

  def found?
    update?
  end

  def add_state?
    update?
  end

  def remove_state?
    update?
  end

  def repairing?
    update?
  end

  def repaired?
    update?
  end

  def swap_line?
    update?
  end

  def swap_results?
    swap_line?
  end
end