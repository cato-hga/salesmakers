class DepartmentsController < ProtectedController
  before_action :verify_authorized

  def index
    authorize Department.new
    @departments = policy_scope(Department).all
  end

  def new
  end

  def edit
  end

  def update
  end

  def create
  end

  def destroy
  end

  def show
    @department = Department.find params[:id]
    authorize @department
    @wall = @department.wall
    @wall_posts = @wall.wall_posts
  end
end
