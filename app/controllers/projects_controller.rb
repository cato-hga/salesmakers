class ProjectsController < ProtectedController
  after_action :verify_authorized, except: [:show, :sales]
  after_action :verify_policy_scoped

  def show
    @project = Project.find params[:id]
    @wall = policy_scope(Wall).find_by wallable: @project
    unless @wall
      flash[:error] = 'Could not find a wall for that project or you are not authorized to view it.'
      redirect_to :back
    end
    @wall_posts = @wall.wall_posts
  end

  def sales
    @project = policy_scope(Project).find params[:id]
    unless @project
      flash[:error] = 'You do not have permission to view sales for that project.'
      redirect_to :back
    end
    @roots = Area.roots.where(project: @project).order(:name)
  end

end