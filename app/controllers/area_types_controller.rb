class AreaTypesController < ProtectedController
  def index
    authorize AreaType.new
    @project = Project.find params[:project_id]
    @area_types = policy_scope(AreaType.where project: @project)
  end

  def show
    @area_type = AreaType.find params[:id]
    authorize @area_type
  end

  def new
    #TODO Authorize
  end

  def create
    #TODO Authorize
  end

  def edit
    #TODO Authorize
  end

  def update
    #TODO Authorize
  end

  def destroy
    #TODO Authorize
  end
end
