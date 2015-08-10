class SeedClientAreaData < ActiveRecord::Migration
  def up
    puts 'Seeding ClientAreaTypes'
    seed_client_area_types
    puts 'Seeding ClientAreas'
    seed_client_areas
    puts 'Seeding LocationClientAreas'
    seed_location_client_areas
  end

  def down
    LocationClientArea.destroy_all
    PersonClientArea.destroy_all
    ClientArea.destroy_all
    ClientAreaType.destroy_all
  end

  private

  def seed_client_area_types
    for area_type in AreaType.all do
      ClientAreaType.create name: area_type.name, project: area_type.project
    end
  end

  def seed_client_areas
    for project in Project.all do
      for area in Area.sort_by_ancestry(project.areas) do
        project = area.project
        name = area.name
        client_area_type = ClientAreaType.find_by name: area.area_type.name, project: project || next
        client_area = ClientArea.new client_area_type: client_area_type,
                                     name: name,
                                     project: project
        if area.root?
          client_area.save
          next
        else
          parent_area = ClientArea.find_by name: area.parent.name, project: project
          puts parent_area.inspect
          client_area.save
          client_area.update parent: parent_area
        end
      end
    end
  end

  def seed_location_client_areas
    for location_area in LocationArea.all do
      location = location_area.location || next
      area = location_area.area || next
      project = area.project
      client_area = project.client_areas.find_by name: area.name || next
      puts LocationClientArea.create location: location, client_area: client_area
    end
  end
end
