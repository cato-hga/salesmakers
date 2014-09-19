class AreasController < ProtectedController
  def index

    @project = Project.find params[:project_id]
    all_areas = policy_scope(Area).where(project: @project).arrange(order: :name)
    if all_areas and not all_areas.empty?
      @areas = all_areas.first.first.siblings.where project: @project
      #authorize @areas
      authorize Area.new
    else
      authorize Area.new
      []
    end
  end

  def show
    @area = Area.find params[:id]
    authorize @area
    @wall = @area.wall
    @wall_posts = @wall.wall_posts
  end

  def new
    #TODO AUTHORIZE MEH
  end

  def update
    #TODO AUTHORIZE MEH
  end

  def destroy
    #TODO AUTHORIZE MEH
  end

  def edit
    #TODO AUTHORIZE MEH
  end

  def create
    #TODO AUTHORIZE MEH
  end
end
