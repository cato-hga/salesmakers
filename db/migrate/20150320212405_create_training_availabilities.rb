class CreateTrainingAvailabilities < ActiveRecord::Migration
  def change
    create_table :training_availabilities do |t|
      t.boolean :able_to_attend, null: false, default: false
      t.integer :training_unavailability_reason_id
      t.text :comments
      t.boolean :monday_am
      t.boolean :monday_pm
      t.boolean :tuesday_am
      t.boolean :tuesday_pm
      t.boolean :wednesday_am
      t.boolean :wednesday_pm
      t.boolean :thursday_am
      t.boolean :thursday_pm
      t.boolean :friday_am
      t.boolean :friday_pm
      t.boolean :saturday_am
      t.boolean :saturday_pm
      t.boolean :sunday_am
      t.boolean :sunday_pm

      t.timestamps null: false
    end
  end
end
