class CreateCandidateSources < ActiveRecord::Migration
  def change
    create_table :candidate_sources do |t|
      t.string :name
      t.boolean :active

      t.timestamps null: false
    end
  end
end
