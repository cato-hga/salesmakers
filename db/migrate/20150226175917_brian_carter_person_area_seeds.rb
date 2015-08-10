class BrianCarterPersonAreaSeeds < ActiveRecord::Migration
  def self.up
    areas = []
    project = Project.find_by name: 'Sprint Retail'
    areas << Area.find_by(project: project, name: 'Sprint Blue Region')
    areas << Area.find_by(project: project, name: 'Sprint Red Region')
    brian = Person.find_by email: 'bcarter@retaildoneright.com'
    areas.each {|a| PersonArea.create area: a, person: brian, manages: true}
  end

  def self.down
    brian = Person.find_by email: 'bcarter@retaildoneright.com'
    brian.person_areas.destroy_all
  end
end
