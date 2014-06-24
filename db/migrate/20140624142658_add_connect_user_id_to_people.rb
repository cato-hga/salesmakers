class AddConnectUserIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :connect_user_id, :string
  end
end
