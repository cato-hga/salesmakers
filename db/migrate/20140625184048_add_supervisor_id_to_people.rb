class AddSupervisorIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :supervisor_id, :integer
  end
end
