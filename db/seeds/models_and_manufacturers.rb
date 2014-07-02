puts "Importing Device Models and Manufacturers"

apple = DeviceManufacturer.create name: 'Apple'
htc = DeviceManufacturer.create name: 'HTC'
samsung = DeviceManufacturer.create name: 'Samsung'
verizon = DeviceManufacturer.create name: 'Verizon'
zte = DeviceManufacturer.create name: 'ZTE'

DeviceModel.create name: 'iPad 4', manufacturer: apple
DeviceModel.create name: 'iPad Mini', manufacturer: apple
DeviceModel.create name: 'Evo View 4G', manufacturer: htc
DeviceModel.create name: 'Galaxy Tab 7"', manufacturer: samsung
DeviceModel.create name: 'Galaxy Tab 3', manufacturer: samsung
DeviceModel.create name: 'Ellipsis 7', manufacturer: verizon
DeviceModel.create name: 'Optik', manufacturer: zte