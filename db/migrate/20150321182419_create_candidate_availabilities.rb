class CreateCandidateAvailabilities < ActiveRecord::Migration
  def change
    create_table :candidate_availabilities do |t|
      t.boolean :monday_first, default: false, null: false
      t.boolean :monday_second, default: false, null: false
      t.boolean :monday_third, default: false, null: false
      t.boolean :tuesday_first, default: false, null: false
      t.boolean :tuesday_second, default: false, null: false
      t.boolean :tuesday_third, default: false, null: false
      t.boolean :wednesday_first, default: false, null: false
      t.boolean :wednesday_second, default: false, null: false
      t.boolean :wednesday_third, default: false, null: false
      t.boolean :thursday_first, default: false, null: false
      t.boolean :thursday_second, default: false, null: false
      t.boolean :thursday_third, default: false, null: false
      t.boolean :friday_first, default: false, null: false
      t.boolean :friday_second, default: false, null: false
      t.boolean :friday_third, default: false, null: false
      t.boolean :saturday_first, default: false, null: false
      t.boolean :saturday_second, default: false, null: false
      t.boolean :saturday_third, default: false, null: false
      t.boolean :sunday_first, default: false, null: false
      t.boolean :sunday_second, default: false, null: false
      t.boolean :sunday_third, default: false, null: false
      t.integer :candidate_id, null: false

      t.timestamps null: false
    end
  end
end
