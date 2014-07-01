class CreateTechnologyServiceProviders < ActiveRecord::Migration
  def change
    create_table :technology_service_providers do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
