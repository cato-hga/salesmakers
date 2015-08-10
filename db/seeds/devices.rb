puts "Importing devices..."

deployed = DeviceState.find_by name: 'Deployed'
repairing = DeviceState.find_by name: 'Repairing'
lost_stolen = DeviceState.find_by name: 'Lost or Stolen'

ipad_4 = DeviceModel.find_by name: 'iPad 4'
ipad_mini = DeviceModel.find_by name: 'iPad Mini'
ipod = DeviceModel.find_by name: 'iPod'
evo_view_4g = DeviceModel.find_by name: 'Evo View 4G'
galaxy_s4 = DeviceModel.find_by name: 'Galaxy S4'
galaxy_tab_7 = DeviceModel.find_by name: 'Galaxy Tab 7"'
galaxy_tab_3 = DeviceModel.find_by name: 'Galaxy Tab 3'
galaxy_tab_4 = DeviceModel.find_by name: 'Galaxy Tab 4'
ellipsis_7 = DeviceModel.find_by name: 'Ellipsis 7'
optik = DeviceModel.find_by name: 'Optik'
pulse = DeviceModel.find_by name: 'Pulse'

air_card = DeviceModel.find_by name: 'Air Card'
credit_card_scanner = DeviceModel.find_by name: 'Credit Card Scanner'
desktop = DeviceModel.find_by name: 'Desktop'
dvd_player = DeviceModel.find_by name: 'DVD Player'
laptop = DeviceModel.find_by name: 'Laptop'
netbook = DeviceModel.find_by name: 'Netbook'
projector = DeviceModel.find_by name: 'Projector'
tv = DeviceModel.find_by name: 'Television'
sprint_hotspot = DeviceModel.find_by name: 'Sprint Hotspot'
verizon_hotspot = DeviceModel.find_by name: 'Verizon Hotspot'

device_state_emails = [
    'researchassets@retaildoneright.com',
    'retired@retaildoneright.com',
    'assets@retaildoneright.com',
    'repair@retaildoneright.com',
    'exchange@retaildoneright.com',
    'suspended@retaildoneright.com'
]

movements = ConnectAssetMovement.ascending_by_asset

# assets = Hash.new
# for movement in movements do
#   assets[movement.connect_asset] = Array.new unless assets[movement.connect_asset]
#   asset_movements = assets[movement.connect_asset]
#   asset_movements.push movement
#   assets[movement.connect_asset] = asset_movements
# end
#
# for records in assets do
#   asset = records[0]
#   movements = records[1]
#   next unless asset and movements
#   next unless asset.serial
#
#
# end

asset_id = '42'
counter = 0
for movement in movements do
  counter += 1
  if counter % 50 == 0
    puts "Imported #{counter.to_s} movements..."
  end
  next unless movement.connect_asset and movement.connect_asset.serial
  # Reset the counter for each new asset
  if asset_id != movement.rc_asset_id
    movement_counter = 0
  end
  # Get the ConnectAsset for the movement
  asset_id = movement.rc_asset_id

  # If no ConnectAsset was retrieved, continue on to the next movement
  next if not asset_id
  # Increment the movement counter for each movement
  movement_counter = movement_counter + 1
  next if movement.moved_to_user.username == 'suspended@retaildoneright.com'
  # Set device to nil in order to detect whether a device was or was not
  # found or created
  device = nil
  # Get the ConnectUser that created the movement
  created_by_connect_user = ConnectUser.find movement.createdby
  # Set created_by to nil in order to detect whether the user was
  # successfully retrieved or not
  created_by = nil
  # Get or create the Person from the created_by ConnectUser
  created_by = Person.return_from_connect_user created_by_connect_user if created_by_connect_user
  # Attempt to get a Device that exists with the serial in
  # question.
  device = Device.find_by_serial movement.connect_asset.serial

  # Only if we're on the first movement for the asset, we'll want
  # to create the Device corresponding to it.
  if movement_counter == 1
    # Set device_model_id to nil in order to detect whether the asset
    # is one of the types we need added
    device_model_id = nil
    # Get the device model for the asset

    case movement.connect_asset.connect_asset_group.name
      when 'iPad 4 (Sprint)'
        device_model_id = ipad_4.id
      when 'iPad 4 (Verizon)'
        device_model_id = ipad_4.id
      when 'iPad Mini (Sprint)'
        device_model_id = ipad_mini.id
      when 'iPad Mini (Verizon)'
        device_model_id = ipad_mini.id
      when 'HTC Evo View 4G'
        device_model_id = evo_view_4g.id
      when 'LG Pulse (Virgin)'
        device_model_id = pulse.id
      when 'Sprint Galaxy S4'
        device_model_id = galaxy_s4.id
      when 'Samsung Galaxy Tab 7" (Sprint)'
        device_model_id = galaxy_tab_7.id
      when 'Samsung Galaxy Tab 7" (Verizon)'
        device_model_id = galaxy_tab_7.id
      when 'Samsung GalaxyTab 3'
        device_model_id = galaxy_tab_3.id
      when 'Samsung Galaxy Tab 4'
        device_model_id = galaxy_tab_4.id
      when 'ZTE Optik Tablet (Sprint)'
        device_model_id = optik.id
      when 'Verizon Ellipsis 7'
        device_model_id = ellipsis_7.id

      when 'Air Card (Sprint)'
        device_model_id = air_card.id
      when 'Credit Card Scanners'
        device_model_id = credit_card_scanner.id
      when 'Desktop'
        device_model_id = desktop.id
      when 'DVD Players'
        device_model_id = dvd_player.id
      when 'iPod'
        device_model_id = ipod.id
      when 'Laptop'
        device_model_id = laptop.id
      when 'Netbook'
        device_model_id = netbook.id
      when 'Projectors'
        device_model_id = projector.id
      when 'TV'
        device_model_id = tv.id
      when 'Hotspot (Sprint)'
        device_model_id = sprint_hotspot.id
      when 'Hotspot (Verizon)'
        device_model_id = verizon_hotspot.id
    end
    # Create the Device only if we have a Model for it
    if device_model_id
      # Set line to nil in case the Device is not attached to a line
      line = nil
      # Get the line for the Device if there is a PTN on the asset
      line = Line.find_by_identifier movement.connect_asset.ptn if movement.connect_asset.ptn
      # Only if there is a Device existing, create it.
      if not device
        # Create the Device from the ConnectAssetMovement
        device = Device.create_from_connect_asset_movement movement.connect_asset.serial,
                                                           device_model_id,
                                                           line,
                                                           movement,
                                                           created_by

      end
    end
  end

  # If the device still was not created on the first movment
  # nor found on subsequent movements, just skip to the next
  # movement.
  next if not device

  # Get the ConnectUsers for the to and from on the movement.
  to_connect_user = movement.moved_to_user
  from_connect_user = movement.moved_from_user

  # Skip to the next movement if we can't get the to/from users.
  next if not to_connect_user or not from_connect_user

  # Set the to/from Persons to nil to detect whether we can return
  # one or not.
  to_person = nil
  from_person = nil
  # Get or create a Person for to/from users if they're not in
  # the device_state_emails
  unless device_state_emails.include? to_connect_user.username
    to_person = Person.return_from_connect_user to_connect_user
  end
  unless device_state_emails.include? from_connect_user
    from_person = Person.return_from_connect_user from_connect_user
  end

  # If we're on the first movement and the to_person is nil, then
  # it was probably moved to asset inventory and we do not need a
  # deployment.
  unless device_state_emails.include? to_connect_user.username
    next if movement_counter == 1 and not to_person
  end

  # Take the appropriate action depending on the to user email
  if to_connect_user.username == 'retired@retaildoneright.com'
    device.write_off_from_connect_asset_movement movement, created_by
  elsif to_connect_user.username == 'assets@retaildoneright.com'
    device.recoup_from_connect_asset_movement movement, created_by
  elsif to_connect_user.username == 'repair@retaildoneright.com'
    device.repair_from_connect_asset_movement movement, created_by
  elsif to_connect_user.username == 'researchassets@retaildoneright.com'
    device.lost_or_stolen_from_connect_asset_movement movement, created_by
  else
    device.deploy_from_connect_asset_movement movement, created_by
  end
end

=begin
assets_counter = 0
connect_assets = ConnectAsset.all
for connect_asset in connect_assets do
  assets_counter = assets_counter + 1
  puts "   - " + assets_counter.to_s + " assets processed..." unless assets_counter % 25 > 0
  device_model_id = nil
  case connect_asset.connect_asset_group.name
    when 'iPad 4 (Sprint)'
      device_model_id = ipad_4.id
    when 'iPad 4 (Verizon)'
      device_model_id = ipad_4.id
    when 'iPad Mini (Sprint)'
      device_model_id = ipad_mini.id
    when 'iPad Mini (Verizon)'
      device_model_id = ipad_mini.id
    when 'HTC Evo View 4G'
      device_model_id = evo_view_4g.id
    when 'Samsung Galaxy Tab 7" (Sprint)'
      device_model_id = galaxy_tab_7.id
    when 'Samsung Galaxy Tab 7" (Verizon)'
      device_model_id = galaxy_tab_7.id
    when 'Samsung GalaxyTab 3'
      device_model_id = galaxy_tab_3.id
    when 'ZTE Optik Tablet (Sprint)'
      device_model_id = optik.id
    when 'Verizon Ellipsis 7'
      device_model_id = ellipsis_7.id
  end

  next unless device_model_id.present?
  device_model = DeviceModel.find device_model_id
  ptn = connect_asset.ptn
  line = nil
  if ptn
    line = Line.find_by_identifier ptn
  end
  serial = connect_asset.serial

  movement_counter = 0
  connect_movements = connect_asset.connect_asset_movements
  for movement in connect_movements
    movement_counter = movement_counter + 1
    created_by = nil
    from_email = movement.moved_from_user.email
    to_email = movement.moved_to_user.email
    created_by_connect_user = ConnectUser.find movement.createdby
    created_by = Person.return_from_connect_user created_by_connect_user unless created_by.present?
    unless device_state_emails.include? to_email
      to_user = Person.return_from_connect_user movement.moved_to_user
    else
      to_user = nil
    end
    person_id = (to_user.present?) ? to_user.id : nil
    if movement_counter == 1
      line = nil
      if ptn.present? and not ptn.blank?
        line = Line.find_by_identifier ptn
      end
      line_id = (line.present?) ? line.id : nil
      device = Device.create_from_connect_asset_movement serial,
                                                         device_model_id,
                                                         line_id,
                                                         person_id,
                                                         movement,
                                                         created_by
    end
    line = Line.find_by_identifier ptn
    device = Device.find_by_serial serial
    next unless device.present? and not device.blank?
    if movement_counter > 1 or to_email != 'assets@retaildoneright.com'
      next if to_email == 'suspended@retaildoneright.com' or from_email == 'suspended@retaildoneright.com'
      device_deployments = device.device_deployments
      last_deployment = (device_deployments.present? and device_deployments.count > 0) ? device_deployments.last : nil
      if to_email == 'retired@retaildoneright.com'
        device.write_off_from_connect_asset_movement movement, created_by
      elsif to_email == 'assets@retaildoneright.com'
        device.recoup_from_connect_asset_movement movement, created_by
      elsif to_email == 'repair@retaildoneright.com'
        device.repair_from_connect_asset_movement movement, created_by
      elsif to_email == 'researchassets@retaildoneright.com'
        device.lost_or_stolen_from_connect_asset_movement movement, created_by
      else
        puts movement.moved_to_user.name unless to_user.present?
        device.deploy_from_connect_asset_movement movement, created_by
      end
    end
  end
end
=end