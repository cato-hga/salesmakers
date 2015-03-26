class DeactivateSprintStores < ActiveRecord::Migration
  def change

    execute "update
            location_areas
            set active = false
            from locations l
            where l.channel_id = 9
              and location_areas.location_id = l.id
              and (l.store_number = '7650' or
              l.store_number = '7314' or
              l.store_number = '7779' or
              l.store_number = '7284' or
              l.store_number = '6880' or
              l.store_number = '7853' or
              l.store_number = '6642' or
              l.store_number = '6719' or
              l.store_number = '7529' or
              l.store_number = '6941' or
              l.store_number = '6783' or
              l.store_number = '7072' or
              l.store_number = '6702')"
  end
end
