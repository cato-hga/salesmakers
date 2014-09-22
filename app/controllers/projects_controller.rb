class ProjectsController < ProtectedController
  after_action :verify_authorized, except: :show
  after_action :verify_policy_scoped

  def show
    @project = Project.find params[:id]
    @wall = policy_scope(Wall).find_by wallable: @project
    unless @wall
      flash[:error] = 'Could not find a wall for that project or you are not authorized to view it.'
      redirect_to :back
    end
  end

  def edit
  end

  def update
  end

  def new
  end

  def create
  end

  def destroy
  end
end