class AreasController < ProtectedController
  after_action :verify_authorized, except: [:index, :show, :sales]
  after_action :verify_policy_scoped, except: [:index, :show]

  def index
    @project = Project.find params[:project_id]
    #@areas = Area.member_of(@current_person).where project: @project
    @areas = Area.roots.where project: @project
  end

  def show
    @area = Area.find params[:id]
    @wall = Wall.find_by wallable: @area
    if policy_scope(Wall).include? @wall
      @show_share_form = true
    else
      @show_share_form = false
    end
    @wall_posts = @wall.wall_posts
  end

  def sales
    @area = policy_scope(Area).find params[:id]
    unless @area
      flash[:error] = 'You do not have permission to view sales for that area.'
      redirect_to :back
    end
  end
end
