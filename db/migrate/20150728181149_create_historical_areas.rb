class CreateHistoricalAreas < ActiveRecord::Migration
  def change
    create_table :historical_areas do |t|
      t.string :name, null: false
      t.integer :area_type_id, null: false
      t.string :ancestry, null: false
      t.integer :project_id, null: false
      t.string :connect_salesregion_id
      t.string :personality_assessment_url
      t.integer :area_candidate_sourcing_group_id
      t.string :email
      t.boolean :active, null: false, default: true

      t.timestamps null: false
    end
  end
end
