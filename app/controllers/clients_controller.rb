class ClientsController < ProtectedController
  after_action :verify_authorized, except: :sales
  after_action :verify_policy_scoped, except: :show

  def index
    authorize Client.new
    @search = policy_scope(Client).search(params[:q])
    @clients = @search.result.order('name').page(params[:page])
  end

  def show
    @client = Client.find params[:id]
    authorize @client
  end

  def sales
    @client = policy_scope(Client).find params[:id]
    unless @client
      flash[:error] = 'You do not have permission to view sales for that client.'
      redirect_to :back
    end
  end
end
