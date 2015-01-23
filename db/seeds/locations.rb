puts "Importing locations..."

LocationArea.destroy_all
Location.destroy_all
Channel.destroy_all

Channel.find_or_create_by name: "Brandsmart"
Channel.find_or_create_by name: "Fry's"
Channel.find_or_create_by name: "Kmart"
Channel.find_or_create_by name: "Micro Center"
Channel.find_or_create_by name: "Vonage Event Teams"
Channel.find_or_create_by name: "Sears"
Channel.find_or_create_by name: "Walmart"

rbdc_channels = ['Brandsmart', "Fry's", 'KMart',
                 'Microcenter', 'RBD Event Teams',
                 'Sears', 'Sprint', 'Walmart']

count = 0
for channel_name in rbdc_channels do
  bp = ConnectBusinessPartner.find_by name: channel_name
  next unless bp
  locs = bp.connect_business_partner_locations.where(isactive: 'Y')
  next unless locs and locs.count > 0
  for loc in locs do
    location = Location.return_from_connect_business_partner_location loc
    count += 1 if location
    if count % 50 == 0
      puts "Imported #{count} locations..."
    end
  end
end