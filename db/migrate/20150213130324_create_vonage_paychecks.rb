class CreateVonagePaychecks < ActiveRecord::Migration
  def change
    create_table :vonage_paychecks do |t|
      t.string :name, null: false
      t.date :wages_start, null: false
      t.date :wages_end, null: false
      t.date :commission_start, null: false
      t.date :commission_end, null: false
      t.datetime :cutoff, null: false

      t.timestamps null: false
    end
  end
end
