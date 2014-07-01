class CreateLinesLineStates < ActiveRecord::Migration
  def change
    create_join_table :lines, :line_states, column_options: { null:true } do |t|
      t.index :line_id
      t.index :line_state_id
    end
  end
end
