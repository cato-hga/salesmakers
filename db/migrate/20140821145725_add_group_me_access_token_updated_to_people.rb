class AddGroupMeAccessTokenUpdatedToPeople < ActiveRecord::Migration
  def change
    add_column :people, :groupme_token_updated, :datetime
  end
end
