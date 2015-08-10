class CreateTrainingUnavailabilityReasons < ActiveRecord::Migration
  def change
    create_table :training_unavailability_reasons do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
