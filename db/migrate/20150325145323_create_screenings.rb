class CreateScreenings < ActiveRecord::Migration
  def change
    create_table :screenings do |t|
      t.integer :person_id, null: false
      t.integer :sex_offender_check, null: false, default: 0
      t.integer :public_background_check, null: false, default: 0
      t.integer :private_background_check, null: false, default: 0
      t.integer :drug_screening, null: false, default: 0

      t.timestamps null: false
    end
  end
end
