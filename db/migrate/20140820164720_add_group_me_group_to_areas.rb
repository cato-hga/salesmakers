class AddGroupMeGroupToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :groupme_group, :string
  end
end
