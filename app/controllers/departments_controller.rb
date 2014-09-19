class DepartmentsController < ProtectedController
  def index
    authorize Department.new
    @departments = policy_scope(Department).all
  end

  def new
    #TODO AUTHORIZE MEH
  end

  def edit
    #TODO AUTHORIZE MEH
  end

  def update
    #TODO AUTHORIZE MEH
  end

  def create
    #TODO AUTHORIZE MEH
  end

  def destroy
    #TODO AUTHORIZE MEH
  end

  def show
    @department = Department.find params[:id]
    authorize @department
    @wall = @department.wall
    @wall_posts = @wall.wall_posts
  end
end
