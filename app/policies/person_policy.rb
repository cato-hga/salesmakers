class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope.visible(person)
    end
  end

  def edit_position?
    update_position?
  end

  def update_position?
    has_permission? 'update_position'
  end

  def update_own_basic?
    has_permission? 'update_own_basic'
  end

  def terminate?
    return true if @user.managed_team_members.include? @record
    return true if has_permission? 'terminate'
    false
  end

  def third_party_nos?
    support = Position.find_by name: 'SalesMakers Support Member'
    develop = Position.find_by name: 'Software Developer'
    return true if @user.position == support or @user.position == develop
    false
  end

  def approval?
    @user.managed_team_members.any?
  end

  def send_asset_form?
    DevicePolicy.new(@user, Device.new).update?
  end

  def masquerade?
    has_permission? 'masquerade'
  end
end
