class DeviceDeploymentsController < ApplicationController
  # Currently not being used
  # def select_user
  #   @device = Device.find params[ :device_id ]
  #   @search = Person.search(params[:q])
  #   @people = @search.result.order('display_name').page(params[:page])
  # end

  def new
    @person = Person.find params[ :person_id ]
    @device = Device.find params[ :device_id ]
    @current_devices = Device.where person: @person
    @device_deployment = DeviceDeployment.new
  end

  def create
    @person = Person.find params[ :person_id ]
    @device = Device.find params[ :device_id ]
    @current_devices = Device.where person: @person
    @device_deployment = DeviceDeployment.new device_params
    @device_deployment.started = Date.today
    @device_deployment.device = @device
    @device_deployment.person = @person
    if @device_deployment.save
      @device.person = @person
      @device.save
      flash[ :notice ] = 'Device Deployed!'
      redirect_to @device
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def end
  end

  def destroy
  end

  private

  def device_params
    params.require( :device_deployment ).permit :tracking_number, :comment
  end
end
