module DeviceStateChangesControllerExtension
  def write_off
    @device = Device.find params[:id]
    written_off = DeviceState.find_by name: 'Written Off'
    @device.device_states << written_off
    @device.save
    @current_person.log? 'write_off', @device, nil
    flash[:notice] = 'Device Written Off!'
    redirect_to @device
  end

  def lost_stolen
    @device = Device.find params[:id]
    lost_stolen_state = DeviceState.find_by name: 'Lost or Stolen'
    if @device.device_states.include? lost_stolen_state
      flash[:error] = 'The device was already reported lost or stolen'
    elsif @device.add_state lost_stolen_state
      report_lost_stolen(@device)
      flash[:notice] = 'Device successfully reported as lost or stolen'
    else
      flash[:error] = 'Could not set device state to lost or stolen'
    end
    redirect_to device_path(@device)
  end

  def found
    @device = Device.find params[:id]
    assigned_person = @device.person if @device.person
    lost_stolen_state = DeviceState.find_by name: 'Lost or Stolen'
    written_off_state = DeviceState.find_by name: 'Written Off'
    if @device.device_states.delete lost_stolen_state, written_off_state
      @current_person.log? 'found',
                           @device
      flash[:notice] = 'Device no longer reported lost or stolen and/or written off'
      redirect_to device_path(@device)
      return if assigned_person == nil
      AssetsMailer.found_mailer(@device).deliver_later
    else
      flash[:error] = 'Could not remove the lost or stolen, or written off states from the device'
      redirect_to device_path(@device)
    end
  end

  def repairing
    @device = Device.find params[:id]
    repairing_state = DeviceState.find_by name: 'Repairing'
    if @device.device_states.include? repairing_state
      flash[:error] = 'The device was already reported as being repaired'
      redirect_to device_path(@device) and return
    end
    if @device.add_state repairing_state
      @current_person.log? 'repairing',
                           @device
      flash[:notice] = 'Device successfully reported as being repaired'
      redirect_to device_path(@device)
    else
      flash[:error] = 'Could not set device state to repairing'
      redirect_to device_path(@device)
    end
  end

  def repaired
    @device = Device.find params[:id]
    repairing_state = DeviceState.find_by name: 'Repairing'
    if @device.device_states.delete repairing_state
      @current_person.log? 'repaired',
                           @device
      flash[:notice] = 'Device reported as repaired'
      redirect_to device_path(@device)
    else
      flash[:error] = 'Could not set device as repaired'
      redirect_to device_path(@device)
    end
  end

  def remove_state
    if @device and @device_state
      deleted = @device.device_states.delete @device_state
      if deleted
        @current_person.log? 'remove_state',
                             @device,
                             @device_state
        flash[:notice] = 'State removed from device'
        redirect_to device_path(@device)
      end
    else
      flash[:error] = 'Could not find that device or device state'
      redirect_to device_path(@device)
    end
  end

  def add_state
    if @device and @device_state
      if @device.add_state @device_state
        @current_person.log? 'add_state',
                             @device,
                             @device_state
        flash[:notice] = 'State added to device'
        redirect_to device_path(@device)
      else
        flash[:error] = 'State could not be added to device'
        redirect_to device_path(@device)
      end
    else
      flash[:error] = 'Could not find that device or device state'
      redirect_to device_path(@device)
    end
  end

  private

  def set_device_and_device_state
    @device = Device.find state_params[:id]
    if state_params[:device_state_id].blank?
      flash[:error] = 'You did not select a state to add'
      redirect_to device_path(@device) and return
    end
    @device_state = DeviceState.find state_params[:device_state_id]
    if @device_state.locked?
      flash[:error] = 'You cannot add or remove built-in device states'
      redirect_to device_path(@device) and return
    end
  end

  def report_lost_stolen(device)
    assigned_person = @device.person if @device.person
    @current_person.log? 'lost_stolen',
                         @device
    return if assigned_person == nil
    AssetsMailer.lost_or_stolen_mailer(@device).deliver_later
  end
end