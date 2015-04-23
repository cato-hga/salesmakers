class PositionsController < ProtectedController
  after_action :verify_authorized

  def index
    authorize Position.new
    @department = Department.find params[:department_id]
    @positions = policy_scope(Position).where department: @department
  end

  def edit_permissions
    @position = Position.find params[:id]
    authorize @position
    @permission_groups = PermissionGroup.all
  end

  def update_permissions
    @position = Position.find params[:id]
    authorize @position
    @position.permissions.clear
    for permission_id in permissions_params[:permissions] do
      permission = Permission.find permission_id
      @position.permissions << permission
    end if permissions_params[:permissions]
    @current_person.log? 'edit_permissions',
                         @position
    flash[:notice] = 'Changes to permissions applied.'
    redirect_to edit_permissions_department_position_path(@position.department, @position)
  end

  private

  def permissions_params
    params.permit permissions: []
  end
end
