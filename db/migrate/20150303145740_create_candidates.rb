class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :suffix
      t.string :mobile_phone, null: false, uniqueness: true
      t.string :email, null: false
      t.string :zip, null: false
      t.integer :project_id, null: false

      t.timestamps null: false
    end
  end
end
