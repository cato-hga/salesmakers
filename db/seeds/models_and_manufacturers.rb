puts "Importing Device Models and Manufacturers"

apple = DeviceManufacturer.create name: 'Apple'
htc = DeviceManufacturer.create name: 'HTC'
lg = DeviceManufacturer.create name: 'LG'
samsung = DeviceManufacturer.create name: 'Samsung'
verizon = DeviceManufacturer.create name: 'Verizon'
zte = DeviceManufacturer.create name: 'ZTE'

DeviceModel.create name: 'iPad 4', device_manufacturer: apple
DeviceModel.create name: 'iPad Mini', device_manufacturer: apple
DeviceModel.create name: 'Evo View 4G', device_manufacturer: htc
DeviceModel.create name: 'Galaxy Tab 7"', device_manufacturer: samsung
DeviceModel.create name: 'Galaxy Tab 3', device_manufacturer: samsung
DeviceModel.create name: 'Ellipsis 7', device_manufacturer: verizon
DeviceModel.create name: 'Optik', device_manufacturer: zte
DeviceModel.create name: 'Pulse', device_manufacturer: lg