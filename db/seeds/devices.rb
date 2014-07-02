puts "Importing devices..."

#Randomly generate Identifer?

connect_assets = ConnectAsset.all
for connect_asset in connect_assets do
  device_model = connect_assets.connect_asset_group #Take out Sprint/Verizon?
  serial = connect_assets.serial


  device = Device.create
end