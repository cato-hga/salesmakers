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
    validate_creator
    validate_device_model
    validate_service_provider
    validate_line_identifier
    validate_serial
    validate_contract_end_date
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
    begin
      validate_creator
      validate_device_model
      validate_service_provider
      validate_line_identifier
      validate_serial
      validate_contract_end_date
    rescue AssetReceiverValidationException
      return false
    end
    true
  end

  def validate_creator
    unless @creator.present? and not @creator.new_record?
      raise AssetReceiverValidationException, 'Could not determine the Creator of the asset record'
    end
  end

  def validate_device_model
    unless @device_model.present? and not @device_model.new_record?
      raise AssetReceiverValidationException, 'Device Model is required'
    end
  end

  def create_line?
    @service_provider.present? or @contract_end_date.present? or @line_identifier.present?
  end

  def validate_service_provider
    if create_line? != @service_provider.present?
      raise AssetReceiverValidationException,
            'A Service Provider is required when Contract End Date and/or Line Identifier is selected'
    end
    return if @service_provider.present? or not create_line?
    unless @service_provider.present? and not @service_provider.new_record?
      raise AssetReceiverValidationException, 'Service Provider is required'
    end
  end

  def validate_line_identifier
    if create_line? != @line_identifier.present?
      raise AssetReceiverValidationException,
            'A Line Identifier is required when Contract End Date and/or Service Provider is selected'
    end
    return unless create_line?
    if @line_identifier.present?
      @line_identifier = @line_identifier.gsub(/[^0-9A-Za-z]/, '')
      unless @line_identifier.length == 10
        raise AssetReceiverValidationException, 'Line Identifier must be 10 characters in length'
      end
    end
  end

  def validate_contract_end_date
    if create_line? != @contract_end_date.present?
      raise AssetReceiverValidationException,
            'A Contract End Date is required when Line Identifier and/or Service Provider is selected'
    end
    return unless create_line?
    unless @contract_end_date.is_a? Date
      raise AssetReceiverValidationException, 'The Contract End Date should be a valid date (MM/DD/YYYY)'
    end
  end

  def validate_serial
    unless @serial.present? and @serial.length >= 6
      raise AssetReceiverValidationException, 'A Serial must be present and at least 6 characters in length'
    end
  end

  def device_identifier
    @device_identifier
  end
end

class AssetReceiverValidationException < StandardError
end
