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
      handle_creation_success
    else
      flash[ :error ] = 'Could not deploy Device!'
      redirect_to 'new'
    end
  end


  def edit
  end

  def update
  end

  def recoup_notes
    @device = Device.find params[:device_id]
  end

  def recoup
    @device = Device.find recoup_params[:device_id]
    @device_deployment = @device.device_deployments.first
    @device_deployment.recoup recoup_params[:notes]
    @current_person.log? 'end',
                         @device_deployment,
                         @device,
                         nil,
                         nil,
                         recoup_params[:notes]
    flash[:notice] = 'Device Recouped!'
    redirect_to @device
  end

  def destroy
  end

  private

  def recoup_params
    params.permit :device_id, :notes
  end

  def device_params
    params.require(:device_deployment).permit :person_id, :device_id, :started , :tracking_number, :comment
  end

  def handle_creation_success
    set_as_deployed
    @current_person.log? 'create',
                         @device_deployment,
                         @device,
                         nil,
                         nil,
                         device_params[:comment]
    send_email_and_text
    flash[ :notice ] = 'Device Deployed!'
    redirect_to @device
  end

  def set_as_deployed
    deployed = DeviceState.find_by name: 'Deployed'
    @device.device_states << deployed if deployed
    @device.person = @person
    @device.save
  end

  def send_email_and_text
    AssetsMailer.asset_deployed(@person, @device_deployment).deliver_later
    message = "Your company-issued asset has just been deployed and will ship with the next FedEx pick-up! " +
        "Check your company email for details."
    gateway = Gateway.new
    gateway.send_text_to_person @person, message, @current_person
  end
end
