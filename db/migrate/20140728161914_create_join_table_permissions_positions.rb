class CreateJoinTablePermissionsPositions < ActiveRecord::Migration
  def change
    create_join_table :permissions, :positions do |t|
      t.index [:permission_id, :position_id]
      t.index [:position_id, :permission_id]
    end
  end
end
