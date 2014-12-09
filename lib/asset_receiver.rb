class AssetReceiver

  def initialize(options = {})
    @creator = options.fetch :creator, nil
    @device_model = options.fetch :device_model, nil
    @service_provider = options.fetch :service_provider, nil
    @line_identifier = options.fetch :line_identifier, nil
    @serial = options.fetch :serial, nil
    @device_identifier = options.fetch :device_identifier, nil
    @device_identifier = @serial unless @device_identifier.present?
    @contract_end_date = options.fetch :contract_end_date, nil
  end

  def receive
    line = Line.create identifier: @line_identifier,
                       contract_end_date: @contract_end_date,
                       technology_service_provider: @service_provider
    device = Device.create device_model: @device_model,
                           serial: @serial,
                           identifier: @device_identifier
    @creator.log? 'create', device
    @creator.log? 'create', line
  end

  def valid?
    valid_creator? and
        valid_device_model? and
        valid_service_provider? and
        valid_line_identifier? and
        valid_serial? and
        valid_contract_end_date?
  end

  def valid_creator?
    @creator.present? and not @creator.new_record?
  end

  def valid_device_model?
    @device_model.present? and not @device_model.new_record?
  end

  def create_line?
    @service_provider.present? or @contract_end_date.present? or @line_identifier.present?
  end

  def valid_service_provider?
    return false if create_line? != @service_provider.present?
    return true unless @service_provider.present?
    @service_provider.present? and not @service_provider.new_record?
  end

  def valid_line_identifier?
    return false if create_line? != @line_identifier.present?
    if @line_identifier.present?
      @line_identifier = @line_identifier.gsub(/[^0-9A-Za-z]/, '')
      @line_identifier.length == 10
    else
      true
    end
  end

  def valid_contract_end_date?
    return false if create_line? != @contract_end_date.present?
    return true if not create_line?
    @contract_end_date.is_a? Date
  end

  def valid_serial?
    @serial.present? and @serial.length >= 6
  end

  def device_identifier
    @device_identifier
  end
end