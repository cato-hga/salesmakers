class AddGroupMeGroupNumToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :group_me_group_num, :string
  end
end
