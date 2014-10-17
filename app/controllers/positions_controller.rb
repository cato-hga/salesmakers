class PositionsController < ProtectedController
  after_action :verify_authorized

  def index
    authorize Position.new
    @department = Department.find params[:department_id]
    @positions = policy_scope(Position).where department: @department
  end

end
