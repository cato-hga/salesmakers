class AddViPtoCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :vip, :boolean, default: false, null: false
  end
end
