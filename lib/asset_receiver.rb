class AssetReceiver

  def initialize(device_model, service_provider, line_identifier, serial, secondary = nil)
    @device_model = device_model
    @service_provider = service_provider
    @line_identifier = line_identifier
    @serial = serial
    @secondary = secondary
  end

  def valid?
    valid_device_model? and
        valid_service_provider? and
        valid_line_identifier? and
        valid_serial?
  end

  def valid_device_model?
    @device_model.present? and not @device_model.new_record?
  end

  def valid_service_provider?
    return false unless @service_provider.present? == @line_identifier.present?
    return true unless @service_provider.present?
    @service_provider.present? and not @service_provider.new_record?
  end

  def valid_line_identifier?
    return false unless @service_provider.present? == @line_identifier.present?
    if @line_identifier.present?
      @line_identifier = @line_identifier.gsub(/[^0-9A-Za-z]/, '')
      @line_identifier.length == 10
    else
      true
    end
  end

  def valid_serial?
    @serial.present? and @serial.length >= 6
  end
end