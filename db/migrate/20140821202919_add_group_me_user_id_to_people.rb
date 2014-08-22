class AddGroupMeUserIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :group_me_user_id, :string
  end
end
