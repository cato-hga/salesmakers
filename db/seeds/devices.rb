puts "Importing devices..."

deployed = DeviceState.find_by_name 'Deployed'
repairing = DeviceState.find_by_name 'Repairing'
lost_stolen = DeviceState.find_by_name 'Lost or Stolen'

ipad_4 = DeviceModel.find_by_name 'iPad 4'
ipad_mini = DeviceModel.find_by_name 'iPad Mini'
evo_view_4g = DeviceModel.find_by_name 'Evo View 4G'
galaxy_tab_7 = DeviceModel.find_by_name 'Galaxy Tab 7"'
galaxy_tab_3 = DeviceModel.find_by_name 'Galaxy Tab 3'
ellipsis_7 = DeviceModel.find_by_name 'Ellipsis 7'
optik = DeviceModel.find_by_name 'Optik'

device_state_emails = [
    'researchassets@retaildoneright.com',
    'assets@retaildoneright.com',
    'repair@retaildoneright.com'
]
assets_counter = 0
connect_assets = ConnectAsset.all
for connect_asset in connect_assets do
  assets_counter = assets_counter + 1
  puts "   - " + assets_counter.to_s + " assets processed..." unless assets_counter % 25 > 0
  device_model_id = nil
  case asset.connect_asset_group.name
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
  person = Person.find_by_connect_user_id connect_asset.ad_user_id
  person = Person.return_from_connect_user connect_asset.connect_user if not person
  person = nil if device_state_emails.include? person.email

  device = Device.create  serial: serial,
                          identifier: serial,
                          device_model: device_model,
                          line: line,
                          person: person

  #TODO: Attach device states


end