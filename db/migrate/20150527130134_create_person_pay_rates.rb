class CreatePersonPayRates < ActiveRecord::Migration
  def change
    create_table :person_pay_rates do |t|
      t.integer :person_id, null: false
      t.integer :wage_type, null: false
      t.float :rate, null: false
      t.date :effective_date, null: false

      t.timestamps null: false
    end
  end
end
