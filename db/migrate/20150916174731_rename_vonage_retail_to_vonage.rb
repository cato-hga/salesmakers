class RenameVonageRetailToVonage < ActiveRecord::Migration
  def up
    vonage_retail = Project.find_by name: 'Vonage Retail'
    return unless vonage_retail
    vonage_retail.update name: 'Vonage'
  end

  def down
    vonage = Project.find_by name: 'Vonage'
    return unless vonage
    vonage.update name: 'Vonage Retail'
  end
end
