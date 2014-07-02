class Device < ActiveRecord::Base

  validates :serial, presence: true, length: { minimum: 6 }
  validates :identifier, presence: true, length:  { minimum: 4 }
  validates :device_model, presence: true

  belongs_to :device_model
  belongs_to :line
  belongs_to :person
  has_and_belongs_to_many :device_states
  has_many :device_deployments
  has_one :device_manufacturer, through: :device_model

  def self.create_from_connect_asset_movement(serial, device_model_id, line_id, person_id, movement, created_by)
    # Create the Device
    device = self.create serial: serial,
                         identifier: serial,
                         device_model_id: device_model_id,
                         line_id: line_id,
                         person_id: person_id

    # Log the creation with the same creation details that are
    # on the Openbravo movement.
    log_entry = LogEntry.create action: 'create',
                                trackable: device,
                                comment: movement.note,
                                created_at: movement.created,
                                updated_at: movement.updated,
                                person_id: created_by.id
    device
  end

  def recoup_from_connect_asset_movement(movement, created_by)
    # Grab all of the deployments for the device
    device_deployments = self.device_deployments
    # Get the most recent deployment (the only one we're interested
    # in)
    most_recent_deployment = (device_deployments.present? and device_deployments.count > 0) ? device_deployments.first : nil
    # Destroy all of the current states attached to the device
    self.device_states.destroy_all
    # If the most recent deployment is still showing as active...
    if most_recent_deployment.present? and not most_recent_deployment.ended.present?
      # Set the end date on the deployment to the creation time of
      # the Openbravo movement.
      most_recent_deployment.ended = movement.created
      # Same thing with the updated date/time.
      most_recent_deployment.updated_at = movement.updated
      # Save the deployment
      most_recent_deployment.save
      # Log the recoup
      log_entry = LogEntry.create action: 'end',
                                  trackable: most_recent_deployment,
                                  comment: movement.note,
                                  created_at: movement.created,
                                  updated_at: movement.updated,
                                  person_id: created_by.id
    end
    # Detach the device from the person
    self.person_id = nil
    # Last updated time should be the movement's last updated time.
    self.updated_at = movement.updated
    # Save the device with all the changes
    self.save
  end

  def deploy_from_connect_asset_movement(movement, created_by)
    # Openbravo email addresses that correspond to DeviceStates
    device_state_emails = [
        'assets@retaildoneright.com',
        'repair@retaildoneright.com',
        'researchassets@retaildoneright.com',
        'exchange@retaildoneright.com',
        'retired@retaildoneright.com'
    ]

    # Get the "Deployed" state from the DB
    deployed = DeviceState.find_by_name 'Deployed'

    # The email address of the user that the Device is moving from
    from_email = movement.moved_from_user.email
    # The email address of the user that the Device is moving to
    email = movement.moved_to_user.email
    # If the _to_ email address is not a state email
    unless device_state_emails.include? email
      # Get or create the User that we're deploying to
      to_person = Person.return_from_connect_user movement.moved_to_user
    else
      # If it's a state email, no User is fetched.
      to_person = nil
    end
    # Recoup the Device if necessary
    self.recoup_from_connect_asset_movement movement, created_by
    # Remove all states from the Device
    self.device_states.destroy_all
    # Add the "Deployed" state to the Device
    self.device_states << deployed
    return
    # Create the new DeviceDeployment with the same creation times
    # and update times as the Openbravo movement.
    new_deployment = self.device_deployments.create started: movement.created,
                                                    tracking_number: movement.tracking,
                                                    comment: movement.note,
                                                    person_id: to_person.id,
                                                    created_at: movement.created,
                                                    updated_at: movement.updated
    # Assign the device to the Person
    self.person_id = to_person.id
    # Set the Device's last updated date/time
    self.updated_at = movement.updated
    # Save the Device with the changes
    self.save
    # If the new deployment was created...
    if new_deployment.present? and new_deployment.id.present?
      # ... log it
      log_entry = LogEntry.create action: 'create',
                                  trackable: new_deployment,
                                  comment: movement.note,
                                  created_at: movement.created,
                                  updated_at: movement.updated,
                                  person_id: created_by.id
    end
  end

  def write_off_from_connect_asset_movement(movement, created_by)
    # Grab the "Deployed" state from the DB
    deployed = DeviceState.find_by_name 'Deployed'
    # Grab the "Written Off" state from the DB
    written_off = DeviceState.find_by_name 'Written Off'
    # Take off all of the states (what we want when we encounter
    # a retired device in Openbravo)
    self.device_states.destroy_all
    # Add back the deployed state
    self.device_states << deployed
    # Attach the written off state
    self.device_states << written_off
    # Take off the wireless line since it's most likely been
    # reassigned to another device by now (or cancelled)
    self.line_id = nil
    # Save the device.
    self.save
    # Log the write-off
    log_entry = LogEntry.create action: 'write_off',
                                trackable: self,
                                comment: movement.note,
                                created_at: movement.created,
                                updated_at: movement.updated,
                                person_id: created_by.id
  end

  # Translate an Openbravo exchange status to the new DB format
  def exchange_from_connect_asset_movement(movement, created_by)
    # Grab the exchange state from the DB
    exchange = DeviceState.find_by_name 'Exchanging'
    # Add the exchange state to the Device
    self.device_states << exchange
    # Log the exchange
    log_entry = LogEntry.create action: 'exchange',
                                trackable: self,
                                comment: movement.note,
                                created_at: movement.created,
                                updated_at: movement.updated,
                                person_id: created_by.id
  end

  # Translate the Openbravo repair movement into the new format
  # of a state in the DB
  def repair_from_connect_asset_movement(movement, created_by)
    # Grab the "Repairing" state from the DB
    repairing = DeviceState.find_by_name 'Repairing'
    # Recoup the asset if it's already deployed
    self.recoup_from_connect_asset_movement movement, created_by
    # Add the repairing state to the Device
    self.device_states << repairing
    # Log the repair
    log_entry = LogEntry.create action: 'repair',
                                trackable: self,
                                comment: movement.note,
                                created_at: movement.created,
                                updated_at: movement.updated,
                                person_id: created_by.id
  end

  def lost_or_stolen_from_connect_asset_movement(movement, created_by)
    lost_or_stolen = DeviceState.find_by_name 'Lost or Stolen'
    self.device_states << lost_or_stolen
    log_entry = LogEntry.create action: 'lost_or_stolen',
                                trackable: self,
                                comment: movement.note,
                                created_at: movement.created,
                                updated_at: movement.updated,
                                person_id: created_by.id
  end
end
