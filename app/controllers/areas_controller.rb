class AreasController < ProtectedController
  after_action :verify_authorized, except: [:index, :show]
  after_action :verify_policy_scoped, except: [:index, :show]

  def index
    @project = Project.find params[:project_id]
    @areas = Area.member_of(@current_person).where project: @project
  end

  def show
    @area = Area.find params[:id]
    @wall = policy_scope(Wall).find_by wallable: @area
    unless @wall
      flash[:error] = 'There is no wall for that area or you do not have permission to view it.'
      redirect_to :back
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
