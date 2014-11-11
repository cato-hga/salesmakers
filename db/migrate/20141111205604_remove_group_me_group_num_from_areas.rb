class RemoveGroupMeGroupNumFromAreas < ActiveRecord::Migration
  def change
    remove_column :areas, :group_me_group_num, :string
  end
end
