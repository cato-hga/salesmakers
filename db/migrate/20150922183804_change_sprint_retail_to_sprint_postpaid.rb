class ChangeSprintRetailToSprintPostpaid < ActiveRecord::Migration
  def up
    project = Project.find_by name: 'Sprint Retail'
    if project
      project.update name: 'Sprint Prepaid'
      for area_type in project.area_types do
        area_type.update name: area_type.name.sub('Sprint Retail', 'Sprint Prepaid')
      end
    end
    department = Department.find_by name: 'Sprint Retail Sales'
    if department
      department.update name: 'Sprint Prepaid Sales'
      for position in department.positions do
        position.update name: position.name.sub('Sprint Retail', 'Sprint Prepaid')
      end
    end
  end

  def down
    project = Project.find_by name: 'Sprint Prepaid'
    if project
      project.update name: 'Sprint Retail'
      for area_type in project.area_types do
        area_type.update name: area_type.name.sub('Sprint Prepaid', 'Sprint Retail')
      end
    end
    department = Department.find_by name: 'Sprint Prepaid Sales'
    if department
      department.update name: 'Sprint Retail Sales'
      for position in department.positions do
        position.update name: position.name.sub('Sprint Prepaid', 'Sprint Retail')
      end
    end
  end
end
