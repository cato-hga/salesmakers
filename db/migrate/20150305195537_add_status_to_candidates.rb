class AddStatusToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :status, :integer, null: false, default: 0
  end
end
