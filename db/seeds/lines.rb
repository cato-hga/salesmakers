puts "Importing lines..."

sprint = TechnologyServiceProvider.find_by_name 'Sprint'
verizon = TechnologyServiceProvider.find_by_name 'Verizon'
active = LineState.find_by_name 'Active'

connect_assets = ConnectAsset.where 'ptn IS NOT NULL'
for connect_asset in connect_assets do
  connect_asset_group = connect_asset.connect_asset_group
  next if not connect_asset_group
  technology_service_provider = (connect_asset_group.name.downcase.include? 'verizon') ? verizon : sprint
  contract_end_date = connect_asset.contract_end_date
  contract_end_date = Date.parse '01/01/1901' if not contract_end_date
  line = Line.find_by_identifier connect_asset.ptn
  next if line
  line = Line.create identifier: connect_asset.ptn,
                     technology_service_provider: technology_service_provider,
                     contract_end_date: contract_end_date
  line.line_states << active
end
