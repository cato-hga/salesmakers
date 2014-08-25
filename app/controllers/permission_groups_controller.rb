class PermissionGroupsController < ProtectedController

  def index
    authorize PermissionGroup.new
  end

  def show
    authorize PermissionGroup.new
  end
end
