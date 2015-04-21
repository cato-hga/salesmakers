class CreateDocusignNos < ActiveRecord::Migration
  def change
    create_table :docusign_nos do |t|
      t.integer :person_id, null: false
      t.boolean :eligible_to_rehire, null: false, default: false
      t.date :termination_date, null: false
      t.date :last_day_worked, null: false
      t.integer :separation_reason_id, null: false
      t.text :remarks
      t.string :envelope_guid, null: false

      t.timestamps null: false
    end
  end
end
