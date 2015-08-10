class AddBotNumToGroupMeGroup < ActiveRecord::Migration
  def change
    add_column :group_me_groups, :bot_num, :string
  end
end
