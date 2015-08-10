class ApplicationPolicy
  attr_reader :user, :record, :permission_keys

  def initialize(user, record, permission_keys = [])
    @user = user
    @record = record
    @permission_keys = permission_keys
  end

  def index?
    has_permission? 'index'
  end

  def show?
    scope.where(:id => record.id).count > 0
  end

  def create?
    has_permission? 'create'
  end

  def new?
    create?
  end

  def update?
    has_permission? 'update'
  end

  def edit?
    update?
  end

  def destroy?
    has_permission? 'destroy'
  end

  def search?
    index?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  protected

  def has_permission?(permission_name)
    key = @record.class.name.underscore + '_' + permission_name
    if permission_keys.empty?
      permissioned_object = if @user and @user.is_a?(Person)
                              @user.position
                            elsif @user and @user.is_a?(ClientRepresentative)
                              @user
                            end || return
      has_key? permissioned_object, key
    else
      permission_keys.include? key
    end
  end

  def has_key? permissioned_object, key
    permissions = Permission.where(key: key)
    return false if permissions.empty?
    for permission in permissions do
      return true if permissioned_object.permissions.include?(permission)
    end
    false
  end
end

