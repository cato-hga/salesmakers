class SeedSprintPrepaidMarketAreaType < ActiveRecord::Migration
  def self.up
    project = Project.find_by name: 'Sprint Retail'
    return unless Project
    AreaType.create name: 'Sprint Retail Market',
                    project: project
  end

  def self.down
    project = Project.find_by name: 'Sprint Retail'
    return unless Project
    AreaType.where(name: 'Sprint Retail Market',
                   project: project).destroy_all
  end
end
