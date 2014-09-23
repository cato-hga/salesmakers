class PositionsController < ProtectedController
  after_action :verify_authorized

  def index
    authorize Position.new
    @department = Department.find params[:department_id]
    @positions = policy_scope(Position).where department: @department
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def destroy
  end

  def update
  end
end
