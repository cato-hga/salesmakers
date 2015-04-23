class CreateWorkmarketAssignments < ActiveRecord::Migration
  def change
    create_table :workmarket_assignments do |t|
      t.integer :project_id, null: false
      t.text :json, null: false
      t.string :workmarket_assignment_num, null: false
      t.string :title, null: false
      t.string :worker_name, null: false
      t.string :worker_first_name
      t.string :worker_last_name
      t.string :worker_email, null: false
      t.float :cost, null: false
      t.datetime :started, null: false
      t.datetime :ended, null: false
      t.string :street_1, null: false
      t.string :street_2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false

      t.timestamps null: false
    end
  end
end
