class AddActiveToComcastLead < ActiveRecord::Migration
  def change
    add_column :comcast_leads, :active, :boolean, null: false, default: true
  end
end
