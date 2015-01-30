class ClearBotIdsForReCreation < ActiveRecord::Migration
  def change
    return unless Rails.env.production?
    sprint = Project.find_by name: 'Sprint Retail'
    return unless sprint
    for area in sprint.areas do
      group = GroupMeGroup.find_by area: area
      next unless group
      group.update bot_num: nil
    end
  end
end
