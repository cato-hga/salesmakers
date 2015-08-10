class DepartmentsController < ProtectedController
  after_action :verify_authorized

  def index
    authorize Department.new
    @departments = policy_scope(Department).all
  end

  def show
    @department = Department.find params[:id]
    authorize @department
    #"#{@wall = @department.wall
    #@wall_posts = @wall.wall_posts
  end
end
