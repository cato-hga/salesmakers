class DeviceDeploymentsController < ApplicationController
  def select_user
    @device = Device.find params[ :device_id ]
    @search = Person.search(params[:q])
    @people = @search.result.order('display_name').page(params[:page])
  end

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
    if @device_deployment.save
      @device.person = @person
      @device.save
      flash[ :notice ] = 'Device Deployed!'
      redirect_to @device
    else
      flash[ :error ] = 'Could not deploy Device!'
      redirect_to 'new'
    end
  end


  def edit
  end

  def update
  end

  def recoup
    @device = Device.find params[:device_id]
    @device_deployment = @device.device_deployments.last
    deployed = DeviceState.find_by name: 'Deployed'
    @device.device_states.delete deployed
    ended = DateTime.now
    @device_deployment.update ended: ended
    @device.update person_id: nil
    log_entry = LogEntry.create action: 'end',
                                trackable: @device_deployment,
                                referenceable: @device,
                                comment: 'Recouped',
                                created_at: ended,
                                updated_at: ended,
                                person: @current_person
    redirect_to @device
  end


  def destroy
  end

  private

  def device_params
    params.require(:device_deployment).permit :person_id, :device_id, :started , :tracking_number, :comment
  end
end
