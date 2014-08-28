class ChangeWallWallableToNullFalse < ActiveRecord::Migration
  def change
    change_column_null :walls, :wallable_type, false
    change_column_null :walls, :wallable_id, false
  end
end
