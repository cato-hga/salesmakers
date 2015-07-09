class AddActiveToArea < ActiveRecord::Migration
  def change
    add_column :areas, :active, :boolean, null: false, default: true
  end
end
