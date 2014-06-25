class AddManagesToPersonAreas < ActiveRecord::Migration
  def change
    add_column :person_areas, :manages, :boolean, default: false, null: false
  end
end
