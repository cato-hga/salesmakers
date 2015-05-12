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

  def csv
    @search = WorkmarketAssignment.
        for_client(current_client_rep.client).
        search(params[:q])
    @assignments = @search.result
    authorize WorkmarketAssignment.new
    respond_to do |format|
      format.html { redirect_to client_access_worker_assignments_path }
      format.csv do
        render csv: @assignments,
               filename: "assignments_#{date_time_string}",
               except: [
                   :id,
                   :json,
                   :workmarket_assignment_num,
                   :worker_email,
                   :cost,
                   :created_at,
                   :updated_at,
                   :workmarket_location_num,
                   :project_id
               ],
               add_methods: [
                   :location_name,
                   :attachment_count,
                   :project_name
               ]
      end
    end
  end

  def destroy
    assignment = WorkmarketAssignment.find params[:id]
    authorize assignment
    assignment.destroy
    redirect_to client_access_worker_assignments_path
  end

end