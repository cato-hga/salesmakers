class ChangeLinesAndLineStatesIdColumnsToNullFalse < ActiveRecord::Migration
  def change
    change_column :line_states_lines, :line_id, :integer, null: false
    change_column :line_states_lines, :line_state_id, :integer, null: false
  end
end
