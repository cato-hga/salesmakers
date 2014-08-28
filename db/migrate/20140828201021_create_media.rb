class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.references :medium, polymorphic: true, null: false
      t.timestamps
    end
  end
end
