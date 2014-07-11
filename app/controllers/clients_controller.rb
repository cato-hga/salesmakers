class ClientsController < ApplicationController
  def index
    @search = Client.search(params[:q])
    @clients = @search.result.order('name').page(params[:page])
  end

  def show
    #@clients = Client.find params[:id]
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
