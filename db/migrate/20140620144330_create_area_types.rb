class CreateAreaTypes < ActiveRecord::Migration
  def change
    create_table :area_types do |t|
      t.string :name, null: false
      t.integer :project_id, null: false

      t.timestamps
    end
  end
end
