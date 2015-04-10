class CreateCandidateDrugTests < ActiveRecord::Migration
  def change
    create_table :candidate_drug_tests do |t|
      t.boolean :scheduled, null: false, default: false
      t.datetime :test_date
      t.text :comments

      t.timestamps null: false
    end
  end
end
