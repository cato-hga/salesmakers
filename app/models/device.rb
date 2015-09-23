# == Schema Information
#
# Table name: devices
#
#  id              :integer          not null, primary key
#  identifier      :string           not null
#  serial          :string           not null
#  device_model_id :integer          not null
#  line_id         :integer
#  person_id       :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Device < ActiveRecord::Base
  extend NonAlphaNumericRansacker

  before_save :set_identifier_when_blank
  before_save :strip_identifying_fields

  validates :serial, presence: true, length: {minimum: 6}, uniqueness: {case_sensitive: false}
  validates :identifier, presence: true, length: {minimum: 4}, uniqueness: {case_sensitive: false}
  validates :device_model, presence: true
  validates :line_id, uniqueness: true, allow_nil: true

  belongs_to :device_model
  belongs_to :line
  belongs_to :person
  has_and_belongs_to_many :device_states
  has_many :device_deployments
  has_many :device_notes
  has_many :log_entries, as: :trackable, dependent: :destroy
  has_many :log_entries, as: :referenceable, dependent: :destroy
  has_one :device_manufacturer, through: :device_model
  has_one :latest_deployment, -> { order(started: :desc).limit(1) }, class_name: 'DeviceDeployment'


  stripping_ransacker(:unstripped_identifier, :identifier, true)
  stripping_ransacker(:unstripped_serial, :serial, true)

  strip_attributes

  searchable do
    text :identifier, boost: 5.0
    text :serial, boost: 5.0
  end

  def repairing?
    repairing = DeviceState.find_or_initialize_by name: 'Repairing'
    self.device_states.include? repairing
  end

  def lost_or_stolen?
    lost_stolen = DeviceState.find_or_initialize_by name: 'Lost or Stolen'
    self.device_states.include? lost_stolen
  end

  def written_off?
    written_off = DeviceState.find_or_initialize_by name: 'Written Off'
    self.device_states.include? written_off
  end

  def add_state(state)
    self.device_states << state
    self.device_states.include? state
  end

  def deployed?
    self.device_deployments.count > 0 and
        not self.device_deployments.first.ended
  end

  def deploy_date_string
    return nil unless deployed?
    self.device_deployments.first.started.strftime '%-m/%-d/%Y'
  end

  def manufacturer_name
    return nil unless self.device_manufacturer
    self.device_manufacturer.name
  end

  def device_model_name
    return '' unless self.device_model
    self.device_model.device_model_name
  end

  def line_identifier
    self.line ? self.line.identifier : nil
  end

  def assignee_name
    self.person ? self.person.display_name : nil
  end

  def csv_identifier
    self.identifier ? "'" + self.identifier : nil
  end

  def csv_serial
    self.serial ? "'" + self.serial : nil
  end

  def csv_line_identifier
    self.line_identifier ? "'" + self.line_identifier : nil
  end

  def technology_service_provider
    return nil unless self.line
    return self.line.technology_service_provider
  end

  def set_identifier_when_blank
    if not self.identifier or self.identifier.blank?
      self.identifier = self.serial
    end
  end

  def strip_identifying_fields
    self.serial = self.serial.
        gsub(/[^0-9A-Za-z]/, '') unless self.serial.blank?
    self.identifier = self.identifier.
        gsub(/[^0-9A-Za-z]/, '') unless self.identifier.blank?
  end

  def update_device(serial, identifier, device_model_id)
    @device.serial = serial
    @device.identifier = identifier
    @device.device_model_id = device_model_id
  end

  def device_state_names
    return unless self.device_states
    names = []
    states = self.device_states
    for state in states do
      names << state.name
    end
    names
  end
end
