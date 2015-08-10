class SeedTargetHeadCounts < ActiveRecord::Migration
  def self.up
    channel = Channel.find_by name: 'Radio Shack' || return
    location_areas = LocationArea.joins(:location).where('locations.channel_id = ?', channel.id)
    location_areas.each { |la| la.update target_head_count: 2 }
  end

  def self.down
    channel = Channel.find_by name: 'Radio Shack' || return
    location_areas = LocationArea.joins(:location).where('locations.channel_id = ?', channel.id)
    location_areas.each { |la| la.update target_head_count: 0 }
  end
end
