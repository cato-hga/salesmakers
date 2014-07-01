class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :identifier, null: false
      t.date :contract_end_date, null: false
      t.integer :technology_service_provider_id, null: false

      t.timestamps
    end
  end
end
