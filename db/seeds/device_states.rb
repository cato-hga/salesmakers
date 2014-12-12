puts "Setting up device states..."
deployed = DeviceState.create name: 'Deployed', locked: true
repairing = DeviceState.create name: 'Repairing', locked: true
written_off = DeviceState.create name: 'Written Off', locked: true
exchanging = DeviceState.create name: 'Exchanging', locked: true
lost_stolen = DeviceState.create name: 'Lost or Stolen', locked: true