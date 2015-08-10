class AddRepostedByPersonIdToWallPosts < ActiveRecord::Migration
  def change
    add_column :wall_posts, :reposted_by_person_id, :integer
  end
end
