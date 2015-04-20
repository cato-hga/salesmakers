class ClientAccess::WorkmarketAssignmentsController < ClientApplicationController
  after_action :verify_authorized

  def index
    @search = WorkmarketAssignment.
        for_client(current_client_rep.client).
        search(params[:q])
    @assignments = @search.result.page(params[:page])
    authorize WorkmarketAssignment.new
  end

  def show
    @assignment = WorkmarketAssignment.find params[:id]
    authorize WorkmarketAssignment.new
  end

end