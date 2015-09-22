class ChangeSprintPostpaidToStar < ActiveRecord::Migration
  def up
    project = Project.find_by name: 'Sprint Postpaid'
    if project
      project.update name: 'STAR'
      for area_type in project.area_types do
        area_type.update name: area_type.name.sub('Sprint Postpaid', 'STAR')
      end
    end
    department = Department.find_by name: 'Sprint RadioShack Sales'
    if department
      department.update name: 'STAR Sales'
      for position in department.positions do
        position.update name: position.name.sub('Sprint RadioShack', 'STAR')
      end
    end
  end
end
