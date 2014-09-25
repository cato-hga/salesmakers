class AddLastSeenToPerson < ActiveRecord::Migration
  def change
    add_column :people, :last_seen, :datetime
  end
end
