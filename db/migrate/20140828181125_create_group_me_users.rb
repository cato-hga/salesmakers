class CreateGroupMeUsers < ActiveRecord::Migration
  def change
    create_table :group_me_users do |t|
      t.string :group_me_user_num
      t.integer :person_id
      t.string :name
      t.string :avatar_url

      t.timestamps
    end
  end
end
