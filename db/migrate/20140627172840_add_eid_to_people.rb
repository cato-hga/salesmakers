class AddEidToPeople < ActiveRecord::Migration
  def change
    add_column :people, :eid, :integer
  end
end
