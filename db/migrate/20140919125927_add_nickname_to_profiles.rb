class AddNicknameToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :nickname, :string
  end
end
