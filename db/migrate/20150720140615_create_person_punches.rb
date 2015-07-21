class CreatePersonPunches < ActiveRecord::Migration
  def change
    create_table :person_punches do |t|
      t.string :identifier, null: false
      t.datetime :punch_time, null: false
      t.integer :in_or_out, null: false
      t.integer :person_id

      t.timestamps null: false
    end

    add_index :person_punches, :punch_time
    add_index :person_punches, :identifier
    add_index :person_punches, :in_or_out
  end
end
