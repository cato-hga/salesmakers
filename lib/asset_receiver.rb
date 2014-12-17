class AssetReceiver
  extend ActiveModel::Naming
  attr_accessor :creator
  attr_accessor :device_model
  attr_accessor :service_provider
  attr_accessor :line_identifier
  attr_accessor :serial
  attr_accessor :device_identifier
  attr_accessor :contract_end_date
  attr_reader :errors

  def initialize(options = {})
    @creator = options.fetch :creator, nil
    @device_model = options.fetch :device_model, nil
    @service_provider = options.fetch :service_provider, nil
    @line_identifier = options.fetch :line_identifier, nil
    @serial = options.fetch :serial, nil
    @device_identifier = options.fetch :device_identifier, nil
    @device_identifier = @serial unless @device_identifier.present?
    @contract_end_date = options.fetch :contract_end_date, nil
    @errors = ActiveModel::Errors.new(self)
  end

  def validate!
    validate_creator
    validate_device_model
    validate_service_provider
    validate_line_identifier
    validate_serial
    validate_contract_end_date
  end

  def valid?
    validate!
    errors.any? ? false : true #If there are errors, return false, if not it's true and valid
  end

  def receive
    validate!
    line = Line.create identifier: @line_identifier,
                       contract_end_date: @contract_end_date,
                       technology_service_provider: @service_provider
    device = Device.create device_model: @device_model,
                           serial: @serial,
                           identifier: @device_identifier,
                           line: line
    @creator.log? 'create', device
    @creator.log? 'create', line
  end

  def validate_creator
    unless @creator.present? and not @creator.new_record?
      errors.add :creator, 'could not be determined for the asset record'
    end
  end

  def validate_device_model
    unless @device_model.present? and not @device_model.new_record?
      errors.add :device_model, 'is required'
    end
  end

  def create_line?
    @service_provider.present? or @contract_end_date.present? or @line_identifier.present?
  end

  def validate_service_provider
    if create_line? != @service_provider.present?
      errors.add :service_provider,
                 'is required when Contract End Date and/or Line Identifier is selected'
    end
    return if @service_provider.present? or not create_line?
    unless @service_provider.present? and not @service_provider.new_record?
      errors.add :service_provider, 'is required'
    end
  end

  def validate_line_identifier
    if create_line? != @line_identifier.present?
      errors.add :line_identifier, 'is required when Contract End Date and/or Service Provider is selected'
    end
    return unless create_line?
    if @line_identifier.present?
      @line_identifier = @line_identifier.gsub(/[^0-9A-Za-z]/, '')
      unless @line_identifier.length == 10
        errors.add :line_identifier, 'must be 10 characters in length'
      end
    end
  end

  def validate_contract_end_date
    @contract_end_date = nil if @contract_end_date.present? and @contract_end_date.length < 1
    if create_line? != @contract_end_date.present?
      errors.add :contract_end_date, 'is required when Line Identifier and/or Service Provider is selected'
    end
    return unless create_line?
    @contract_end_date = Chronic.parse(@contract_end_date)
    @contract_end_date = @contract_end_date.to_date if @contract_end_date.present?
    unless @contract_end_date.present?
      errors.add :contract_end_date, 'is invalid or incorrectly formatted'
    end
  end

  def validate_serial
    unless @serial.present? and @serial.length >= 6
      errors.add :serial, 'must be present and at least 6 characters in length'
    end
  end

  def device_identifier
    @device_identifier
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def AssetReceiver.human_attribute_name(attr, options = {})
    attr
  end

  def AssetReceiver.lookup_ancestors
    [self]
  end
end
