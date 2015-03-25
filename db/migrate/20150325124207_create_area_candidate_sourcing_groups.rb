class CreateAreaCandidateSourcingGroups < ActiveRecord::Migration
  def change
    create_table :area_candidate_sourcing_groups do |t|
      t.integer :group_number
      t.integer :project_id, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
