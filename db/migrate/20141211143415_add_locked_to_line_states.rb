class AddLockedToLineStates < ActiveRecord::Migration
  def change
    add_column :line_states, :locked, :boolean, default: false
  end
end
