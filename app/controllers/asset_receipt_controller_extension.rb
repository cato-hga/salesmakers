module AssetReceiptControllerExtension
  def create
    prepare_receipt
    unless has_rows?
      flash[:error] = 'You did not enter any device information'
      render :new and return
    end
    attempt_receipt
    if @bad_receivers.empty?
      flash[:notice] = 'All assets received successfully'
      redirect_to devices_path
    else
      render :new
    end
  end

  def prepare_receipt
    @bad_receivers = Array.new
    @device = Device.new
    set_device_variables
    set_line_variables
    clean_blank_rows
  end

  def set_device_variables
    @device_model = DeviceModel.find receive_params[:device_model_id] unless receive_params[:device_model_id].blank?
    @serials = receive_params[:serial]
    @device_identifiers = receive_params[:device_identifier]
  end

  def set_line_variables
    @line_identifiers = receive_params[:line_identifier]
    @service_provider = TechnologyServiceProvider.find receive_params[:technology_service_provider_id] unless receive_params[:technology_service_provider_id].blank?
    @contract_end_date = receive_params[:contract_end_date]
  end

  private

  def receive_params
    params.permit :contract_end_date, :device_model_id, :technology_service_provider_id, serial: [], line_identifier: [],
                  device_identifier: []
  end

  def clean_blank_rows
    non_blank_serials = Array.new
    non_blank_line_ids = Array.new
    serial_count = -1
    for serial in @serials do
      serial_count += 1
      next if serial.blank? and @line_identifiers[serial_count].blank?
      non_blank_serials << serial
      non_blank_line_ids << @line_identifiers[serial_count]
    end
    @serials = non_blank_serials
    @line_identifiers = non_blank_line_ids
  end

  def has_rows?
    @serials.count > 0 or @line_identifiers.count > 0
  end

  def attempt_receipt
    serial_count = 0
    for serial in @serials do
      line_identifier = @line_identifiers[serial_count]
      @device_identifiers.present? ? device_identifier = @device_identifiers[serial_count] : nil
      receiver = receive_device serial, device_identifier, line_identifier
      receiver.valid? ? receiver.receive : @bad_receivers <<(receiver)
      serial_count += 1
    end
  end

  def receive_device(serial, device_identifier, line_identifier)
    return if serial.blank? and line_identifier.blank?
    AssetReceiver.new contract_end_date: @contract_end_date,
                      device_model: @device_model,
                      service_provider: @service_provider,
                      serial: serial,
                      line_identifier: line_identifier,
                      device_identifier: device_identifier,
                      creator: @current_person
  end
end