puts "Importing Device Models and Manufacturers"

apple = DeviceManufacturer.create name: 'Apple'
htc = DeviceManufacturer.create name: 'HTC'
lg = DeviceManufacturer.create name: 'LG'
samsung = DeviceManufacturer.create name: 'Samsung'
verizon = DeviceManufacturer.create name: 'Verizon'
zte = DeviceManufacturer.create name: 'ZTE'

DeviceModel.create name: 'iPad 4', device_manufacturer: apple
DeviceModel.create name: 'iPad Mini', device_manufacturer: apple
DeviceModel.create name: 'iPod', device_manufacturer: apple
DeviceModel.create name: 'Evo View 4G', device_manufacturer: htc
DeviceModel.create name: 'Galaxy S4', device_manufacturer: samsung
DeviceModel.create name: 'Galaxy Tab 7"', device_manufacturer: samsung
DeviceModel.create name: 'Galaxy Tab 3', device_manufacturer: samsung
DeviceModel.create name: 'Galaxy Tab 4', device_manufacturer: samsung
DeviceModel.create name: 'Ellipsis 7', device_manufacturer: verizon
DeviceModel.create name: 'Optik', device_manufacturer: zte
DeviceModel.create name: 'Pulse', device_manufacturer: lg

generic = DeviceManufacturer.create name: 'Generic'

DeviceModel.create name: 'Air Card', device_manufacturer: generic
DeviceModel.create name: 'Credit Card Scanner', device_manufacturer: generic
DeviceModel.create name: 'Desktop', device_manufacturer: generic
DeviceModel.create name: 'DVD Player', device_manufacturer: generic
DeviceModel.create name: 'Laptop', device_manufacturer: generic
DeviceModel.create name: 'Netbook', device_manufacturer: generic
DeviceModel.create name: 'Projector', device_manufacturer: generic
DeviceModel.create name: 'Television', device_manufacturer: generic
DeviceModel.create name: 'Sprint Hotspot', device_manufacturer: generic
DeviceModel.create name: 'Verizon Hotspot', device_manufacturer: generic