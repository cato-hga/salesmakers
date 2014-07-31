class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    has_permission? 'index'
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  protected

  def has_permission?(permission_name)
    key = @record.class.name.underscore + '_' + permission_name
    puts @user.inspect
    puts @user.position.inspect
    return false unless @user and @user.position
    permission = Permission.find_by key: key
    return false unless permission
    @user.position.permissions.include? permission
  end
end

