class CreateClientRepresentativesPermissionsJoinTable < ActiveRecord::Migration
  def change
    create_table :client_representatives_permissions, id: false do |t|
      t.integer :client_representative_id
      t.integer :permission_id
    end
  end
end
