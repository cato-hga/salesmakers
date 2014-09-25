class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.integer :person_id
      t.date :start
      t.date :end
      t.string :end_reason

      t.timestamps
    end
  end
end
