class AreasController < ProtectedController
  after_action :verify_authorized, except: [:index, :show]
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
  end

  def new
  end

  def update
  end

  def destroy
  end

  def edit
  end

  def create
  end
end
