class AddPersonIdToComcastEod < ActiveRecord::Migration
  def change
    add_column :comcast_eods, :person_id, :integer
  end
end
