class SeedDripDropAndSodaStream < ActiveRecord::Migration
  def self.up
    drip_drop = Client.create name: 'DripDrop'
    soda_stream = Client.create name: 'SodaStream'
    Project.create name: 'DripDrop - AAFES',
                   client: drip_drop,
                   workmarket_project_num: '10005'
    Project.create name: 'SodaStream - Bed Bath & Beyond',
                   client: soda_stream,
                   workmarket_project_num: '10009'
  end

  def self.down
    WorkmarketField.destroy_all
    WorkmarketAttachment.destroy_all
    WorkmarketAssignment.destroy_all
    WorkmarketLocation.destroy_all
    Project.where(name: 'DripDrop - AAFES').destroy_all
    Project.where(name: 'SodaStream - Bed Bath & Beyond').destroy_all
    Client.where(name: 'DripDrop').destroy_all
    Client.where(name: 'SodaStream').destroy_all
  end
end
