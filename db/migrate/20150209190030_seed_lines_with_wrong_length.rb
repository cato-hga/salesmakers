class SeedLinesWithWrongLength < ActiveRecord::Migration
  def self.up
    puts "Importing lines not previously imported..."

    sprint = TechnologyServiceProvider.find_by_name 'Sprint'
    verizon = TechnologyServiceProvider.find_by_name 'Verizon'
    active = LineState.find_by_name 'Active'

    connect_assets = ConnectAsset.where 'char_length(ptn) > 10'
    puts "Found #{connect_assets.count} lines to import..."
    for connect_asset in connect_assets do
      connect_asset_group = connect_asset.connect_asset_group
      next if not connect_asset_group
      technology_service_provider = (connect_asset_group.name.downcase.include? 'verizon') ? verizon : sprint
      contract_end_date = connect_asset.contract_end_date
      contract_end_date = Date.parse '01/01/1901' if not contract_end_date
      line = Line.find_by_identifier connect_asset.line_identifier
      next if line or connect_asset.line_identifier.blank? or connect_asset.line_identifier.length != 10
      line = Line.create identifier: connect_asset.ptn,
                         technology_service_provider: technology_service_provider,
                         contract_end_date: contract_end_date
      line.line_states << active
      next unless line and line.persisted?
      device = Device.find_by serial: connect_asset.serial
      if device
        puts "Found device #{device.serial} to attach to line..."
        device.update line: line
      else
        puts "Did not find a matching device for the line #{line.identifier}"
      end
    end
  end
end
