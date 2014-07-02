class DevicesController < ApplicationController
  def index
    @search = Device.search(params[:q])
    @devices = @search.result.order('serial').page(params[:page])
  end

  def show
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
