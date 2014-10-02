class AddLastSeenToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :last_seen, :datetime
  end
end
