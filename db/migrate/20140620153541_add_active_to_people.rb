class AddActiveToPeople < ActiveRecord::Migration
  def change
    add_column :people, :active, :boolean, null: false, default: true
  end
end
