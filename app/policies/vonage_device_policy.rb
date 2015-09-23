class VonageDevicePolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     scope
  #   end
  # end

  def show?
    has_permission? 'create'
  end

  def transfer?
    has_permission? 'transfer'
  end

  def do_transfer?
    transfer?
  end

  def accept?
    has_permission? 'accept'
  end

  def do_accept?
    accept?
  end

  def reclaim?
    has_permission? 'reclaim'
  end

  def do_reclaim?
    reclaim?
  end

  def employees_reclaim?
    reclaim?
  end
end
