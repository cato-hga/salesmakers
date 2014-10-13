class AreaTypesController < ProtectedController
  after_action :verify_authorized

  def index
    authorize AreaType.new
    @project = Project.find params[:project_id]
    @area_types = policy_scope(AreaType.where project: @project)
  end

  def show
    @area_type = AreaType.find params[:id]
    authorize @area_type
  end
end
