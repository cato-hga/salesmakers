class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.boolean :corporate, null: false

      t.timestamps
    end
  end
end
