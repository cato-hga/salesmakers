class AddAvatarUidToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :avatar_uid, :string
  end
end
