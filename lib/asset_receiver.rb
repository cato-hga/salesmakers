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
    self.creator = options.fetch :creator, nil
    self.device_model = options.fetch :device_model, nil
    self.service_provider = options.fetch :service_provider, nil
    self.line_identifier = options.fetch :line_identifier, nil
    self.serial = options.fetch :serial, nil
    self.device_identifier = options.fetch :device_identifier, nil
    self.device_identifier = self.serial unless self.device_identifier.present?
    self.contract_end_date = options.fetch :contract_end_date, nil
    @errors = ActiveModel::Errors.new(self)
  end

  def validate!
    validate_creator
    validate_device_model
    validate_service_provider
    validate_line_identifier
    validate_line_identifier_unused
    validate_serial
    validate_serial_unused
    validate_device_identifier
    validate_device_identifier_unused
    validate_contract_end_date

  end

  def valid?
    validate!
    errors.any? ? false : true #If there are errors, return false, if not it's true and valid
  end

  def receive
    validate!
    device = Device.create device_model: self.device_model,
                           serial: self.serial,
                           identifier: self.device_identifier
    self.creator.log? 'create', device
    if create_line?
      line = Line.create identifier: self.line_identifier,
                         contract_end_date: self.contract_end_date,
                         technology_service_provider: self.service_provider
      active_state = LineState.find_by name: 'Active'
      line.line_states << active_state
      self.creator.log? 'create', line
      device.update line: line
    end
  end

  def validate_creator
    unless self.creator.present? and not self.creator.new_record?
      errors.add :creator, 'A Creator could not be determined for the asset record'
    end
  end

  def validate_device_model
    if self.device_model.blank?
      errors.add :device_model, 'A Device Model is required'
    end
  end

  def create_line?
    self.service_provider.present? or self.contract_end_date.present? or self.line_identifier.present?
  end

  def validate_service_provider
    if create_line? == self.service_provider.blank?
      errors.add :service_provider,
                 'A Service Provider is required when Contract End Date and/or Line Identifier is selected'
    end
    return unless self.service_provider.blank? and not create_line?
    if not self.service_provider.blank? and not self.service_provider.new_record?
      errors.add :service_provider, 'A Service Provider is required'
    end
  end

  def validate_line_identifier
    if create_line? != self.line_identifier.present?
      errors.add :line_identifier,
                 'A Line Identifier is required when Contract End Date and/or Service Provider is selected'
    end
    return unless create_line?
    if self.line_identifier.present?
      self.line_identifier = self.line_identifier.gsub(/[^0-9A-Za-z]/, '')
      unless self.line_identifier.length == 10
        errors.add :line_identifier, 'A Line Identifier must be 10 characters in length'
      end
    end
  end

  def validate_line_identifier_unused
    return unless create_line?
    existing_lines = Line.where(identifier: self.line_identifier)
    unless existing_lines.empty?
      errors.add :line_identifier, 'Line Identifier has already been entered'
    end
  end

  def validate_contract_end_date
    self.contract_end_date = nil if self.contract_end_date.present? and
        not self.contract_end_date.is_a?(Date) and self.contract_end_date.length < 1
    if create_line? != self.contract_end_date.present?
      errors.add :contract_end_date,
                 'A Contract End Date is required when Line Identifier and/or Service Provider is selected'
    end
    return unless create_line?
    return if self.contract_end_date.is_a?(Date)
    self.contract_end_date = Chronic.parse(self.contract_end_date)
    self.contract_end_date = self.contract_end_date.to_date if self.contract_end_date.present?
    unless self.contract_end_date.present?
      errors.add :contract_end_date, 'Contract End Date is invalid or incorrectly formatted'
    end
  end

  def validate_serial
    unless self.serial.present? and self.serial.length >= 6
      errors.add :serial, 'A Serial must be present and at least 6 characters in length'
    end
  end

  def validate_serial_unused
    existing_devices = Device.where(serial: self.serial)
    unless existing_devices.empty?
      errors.add :serial, 'Serial has already been entered'
    end
  end

  def validate_device_identifier
    unless self.device_identifier.present? and self.device_identifier.length >= 4
      errors.add :device_identifier, 'A Device Identifier must be present and at least 4 characters in lenght'
    end
  end

  def validate_device_identifier_unused
    existing_devices = Device.where(identifier: self.device_identifier)
    unless existing_devices.empty?
      errors.add :device_identifier, 'Device Identifier has already been entered'
    end
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
