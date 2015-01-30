require 'apis/groupme'

class CreateSprintGroupMeGroups < ActiveRecord::Migration
  def self.up
    return unless Rails.env.production?
    sprint = Project.find_by name: 'Sprint Retail'
    return unless sprint
    for area in sprint.areas do
      group_name = GroupMeGroup.generate_group_name area
      next unless group_name
      groupme = GroupMe.new_global
      group = groupme.create_group group_name, area
    end
  end

  def self.down
  end
end
