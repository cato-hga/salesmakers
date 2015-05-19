class CreateDirecTVFormerProviders < ActiveRecord::Migration
  def change
    create_table :directv_former_providers do |t|
      t.integer "directv_sale_id"
      t.string "name", null: false
      t.timestamps null: false
    end
  end
end
