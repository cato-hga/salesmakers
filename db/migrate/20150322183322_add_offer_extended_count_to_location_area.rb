class AddOfferExtendedCountToLocationArea < ActiveRecord::Migration
  def change
    add_column :location_areas, :offer_extended_count, :integer, null: false, default: 0
  end
end
