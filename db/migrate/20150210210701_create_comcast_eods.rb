class CreateComcastEods < ActiveRecord::Migration
  def change
    create_table :comcast_eods do |t|
      t.datetime :eod_date, null: false
      t.belongs_to :location, null: false
      t.boolean :sales_pro_visit, null: false
      t.text :sales_pro_visit_takeaway
      t.boolean :comcast_visit, null: false
      t.text :comcast_visit_takeaway
      t.boolean :cloud_training, null: false
      t.text :cloud_training_takeaway

      t.timestamps null: false
    end
  end
end
