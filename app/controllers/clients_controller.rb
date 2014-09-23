class ClientsController < ProtectedController
  before_action :verify_authorized

  def index
    authorize Client.new
    @search = policy_scope(Client).search(params[:q])
    @clients = @search.result.order('name').page(params[:page])
  end

  def show
    @client = Client.find params[:id]
    authorize @client
  end

  def new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end
end
