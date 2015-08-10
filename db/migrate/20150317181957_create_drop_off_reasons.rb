class CreateDropOffReasons < ActiveRecord::Migration
  def change
    create_table :drop_off_reasons do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false
      t.boolean :eligible_for_reschedule, default: true, null: false

      t.timestamps null: false
    end
  end
end
