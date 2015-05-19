class CreateDirecTV < ActiveRecord::Migration
  def change
    directv = Project.find_by name: 'DirecTV Retail'
    AreaType.create name: 'DirecTV Retail Market', project: directv
  end
end
