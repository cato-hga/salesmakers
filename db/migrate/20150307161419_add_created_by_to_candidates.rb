class AddCreatedByToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :created_by, :integer, null: false
  end
end
