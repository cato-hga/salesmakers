class ChangePersonPositionToNullTrue < ActiveRecord::Migration
  def change
    change_column :people, :position_id, :integer, null: true
  end
end
