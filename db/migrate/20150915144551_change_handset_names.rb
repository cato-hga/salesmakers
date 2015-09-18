class ChangeHandsetNames < ActiveRecord::Migration
  def up
    carrier = SprintCarrier.find_by name: 'Boost Mobile'
    SprintHandset.find_or_create_by name: 'ZTE Warp 4G', sprint_carrier: carrier if carrier
    handset = SprintHandset.find_by name: 'LG TributeLG Volt'
    handset.update name: 'LG Tribute' if handset
    carrier = SprintCarrier.find_by name: 'BB2Go'
    SprintHandset.find_or_create_by name: 'Sierra Overdrive Pro', sprint_carrier: carrier if carrier
    carrier = SprintCarrier.find_by name: 'Virgin Mobile Data Share'
    SprintHandset.find_or_create_by name: 'LG Volt', sprint_carrier: carrier if carrier
  end

  def down
    carrier = SprintCarrier.find_by name: 'Virgin Mobile Data Share'
    if carrier
      handset = SprintHandset.find_by name: 'LG Volt', carrier: carrier
      handset.destroy if handset
    end
    handset = SprintHandset.find_by name: 'Sierra Overdrive Pro'
    handset.destroy if handset
    handset = SprintHandset.find_by name: 'LG Tribute'
    handset.update name: 'LG TributeLG Volt' if handset
    handset = SprintHandset.find_by name: 'ZTE Warp 4G'
    handset.destroy if handset
  end
end
