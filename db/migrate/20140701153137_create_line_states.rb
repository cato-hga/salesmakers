class CreateLineStates < ActiveRecord::Migration
  def change
    create_table :line_states do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
