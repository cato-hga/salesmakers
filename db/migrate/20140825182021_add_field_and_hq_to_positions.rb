class AddFieldAndHqToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :field, :boolean
    add_column :positions, :hq, :boolean
  end
end
