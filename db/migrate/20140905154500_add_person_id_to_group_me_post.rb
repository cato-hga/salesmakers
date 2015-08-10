class AddPersonIdToGroupMePost < ActiveRecord::Migration
  def change
    add_column :group_me_posts, :person_id, :integer
  end
end
