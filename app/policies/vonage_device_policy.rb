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
end
