class ClearBotIdsForReCreation < ActiveRecord::Migration
  def change
    return unless Rails.env.production?
    sprint = Project.find_by name: 'Sprint Retail'
    for area in sprint.areas do
      area.update bot_num: nil
    end
  end
end
