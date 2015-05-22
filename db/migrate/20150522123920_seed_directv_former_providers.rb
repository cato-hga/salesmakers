class SeedDirecTVFormerProviders < ActiveRecord::Migration
  def self.up
    DirecTVFormerProvider.find_or_create_by name: 'AT&T Uverse'
    DirecTVFormerProvider.find_or_create_by name: 'Time Warner'
    DirecTVFormerProvider.find_or_create_by name: 'Cox Communication'
    DirecTVFormerProvider.find_or_create_by name: 'Charter Communications'
    DirecTVFormerProvider.find_or_create_by name: 'CenturyLink'
    DirecTVFormerProvider.find_or_create_by name: 'Comcast'
    DirecTVFormerProvider.find_or_create_by name: 'DISH Network'
    DirecTVFormerProvider.find_or_create_by name: 'Verizon FiOS'
    DirecTVFormerProvider.find_or_create_by name: 'Just moved'
    DirecTVFormerProvider.find_or_create_by name: 'Never had service'
    DirecTVFormerProvider.find_or_create_by name: 'Other'
  end

  def self.down
    DirecTVFormerProvider.destroy_all
  end
end
