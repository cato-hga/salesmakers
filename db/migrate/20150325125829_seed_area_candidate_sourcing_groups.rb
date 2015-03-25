class SeedAreaCandidateSourcingGroups < ActiveRecord::Migration
  def self.up
    project = Project.find_by name: 'Sprint Postpaid'
    AreaCandidateSourcingGroup.create group_number: 1,
                                      name: 'Major Metro Areas',
                                      project: project
    AreaCandidateSourcingGroup.create group_number: 2,
                                      name: 'Second-Tier Markets',
                                      project: project
    AreaCandidateSourcingGroup.create group_number: 3,
                                      name: 'Outsourced',
                                      project: project
  end

  def self.down
    AreaCandidateSourcingGroup.destroy_all
  end
end
