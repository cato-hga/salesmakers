class ClientsController < ProtectedController
  def index
    authorize Client.new
    @search = policy_scope(Client).search(params[:q])
    @clients = @search.result.order('name').page(params[:page])
  end

  def show
    #@clients = Client.find params[:id]
    #TODO AUTHORIZE MEH

  end

  def new
    #TODO AUTHORIZE MEH

  end

  def create
    #TODO AUTHORIZE MEH

  end

  def destroy
    #TODO AUTHORIZE MEH

  end

  def edit
    #TODO AUTHORIZE MEH

  end

  def update
    #TODO AUTHORIZE MEH

  end
end
