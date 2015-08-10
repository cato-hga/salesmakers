class AddLaunchGroupToLocationArea < ActiveRecord::Migration
  def self.up
    add_column :location_areas, :launch_group, :integer
    project = Project.find_by name: 'Sprint Postpaid' || return
    project.areas.each do |area|
      area.location_areas.each do |location_area|
        next unless location_area.active? and location_area.target_head_count > 0
        location_area.update launch_group: 1
      end
    end
  end

  def self.down
    remove_column :location_areas, :launch_group
  end
end
