class SeedComcastFormerProviders < ActiveRecord::Migration
  def self.up
    ComcastFormerProvider.find_or_create_by name: 'AT&T Uverse'
    ComcastFormerProvider.find_or_create_by name: 'CenturyLink'
    ComcastFormerProvider.find_or_create_by name: 'DIRECTV'
    ComcastFormerProvider.find_or_create_by name: 'DISH Network'
    ComcastFormerProvider.find_or_create_by name: 'Verizon FiOS'
    ComcastFormerProvider.find_or_create_by name: 'Just moved'
    ComcastFormerProvider.find_or_create_by name: 'Never had service'
    ComcastFormerProvider.find_or_create_by name: 'Other'
  end

  def self.down
    ComcastFormerProvider.destroy_all
  end
end
