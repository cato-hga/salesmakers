class CreateEmploymentEndReasons < ActiveRecord::Migration
  def change
    create_table :employment_end_reasons do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: false

      t.timestamps null: false
    end
  end
end
