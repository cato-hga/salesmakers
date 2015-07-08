class ClientAreasController < ProtectedController
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, except: [:index]

  def index
    @project = Project.find params[:project_id]
    #@areas = Area.member_of(@current_person).where project: @project
    @client_areas = ClientArea.roots.where project: @project
  end
end
