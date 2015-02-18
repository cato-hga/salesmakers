class AddDefaultFalseToComcastEodFields < ActiveRecord::Migration
  def change
    change_column :comcast_eods, :sales_pro_visit, :boolean, null: false, default: false
    change_column :comcast_eods, :comcast_visit, :boolean, null: false, default: false
    change_column :comcast_eods, :cloud_training, :boolean, null: false, default: false
  end
end
