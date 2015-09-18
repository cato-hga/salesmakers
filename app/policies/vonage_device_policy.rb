class VonageDevicePolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     scope
  #   end
  # end

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
end
