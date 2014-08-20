class AddGroupMeAccessTokenToPeople < ActiveRecord::Migration
  def change
    add_column :people, :groupme_access_token, :string
  end
end
