class AddInterestsAndBioToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :interests, :text
    add_column :profiles, :bio, :text
  end
end
