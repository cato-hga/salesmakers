class AddImageUidToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :image_uid, :string
  end
end
