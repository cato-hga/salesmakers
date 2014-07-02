puts "Setting up device states..."
deployed = DeviceState.create name: 'Deployed'
repairing = DeviceState.create name: 'Repairing'
written_off = DeviceState.create name: 'Written Off'
exchanging = DeviceState.create name: 'Exchanging'
lost_stolen = DeviceState.create name: 'Lost or Stolen'