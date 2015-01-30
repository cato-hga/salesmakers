class RemoveGroupMeGroupIdsFromDatabase < ActiveRecord::Migration
  def self.up
    remove_column :areas, :groupme_group
    for group_me_group in GroupMeGroup.all
      group_me_group.update area_id: nil
    end
  end

  def self.down
    add_column :areas, :groupme_group, :string
  end
end
