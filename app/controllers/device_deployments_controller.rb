class DeviceDeploymentsController < ApplicationController
  def select_user
    @device = Device.find params[ :device_id ]
    @search = Person.search(params[:q])
    @people = @search.result.order('display_name').page(params[:page])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def end
  end

  def destroy
  end
end
