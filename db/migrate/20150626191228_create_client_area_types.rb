class CreateClientAreaTypes < ActiveRecord::Migration
  def change
    create_table :client_area_types do |t|
      t.string :name, null: false
      t.integer :project_id, null: false

      t.timestamps
    end
  end
end
