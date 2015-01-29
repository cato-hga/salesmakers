class CreateComcastFormerProviders < ActiveRecord::Migration
  def change
    create_table :comcast_former_providers do |t|
      t.string :name, null: false
      t.belongs_to :comcast_sale

      t.timestamps null: false
    end
  end
end
