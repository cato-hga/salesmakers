class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.boolean :corporate

      t.timestamps
    end
  end
end
