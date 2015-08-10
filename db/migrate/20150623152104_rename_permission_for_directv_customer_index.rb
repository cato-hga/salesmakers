class RenamePermissionForDirecTVCustomerIndex < ActiveRecord::Migration
  def self.up
    permissions = Permission.where key: 'directv_customer_index'
    permissions.each do |permission|
      permission.update description: 'view list of DirecTV customers'
    end
    permissions = Permission.where "description ILIKE 'can %'"
    permissions.each do |permission|
      new_description = permission.description.gsub('can ', '').gsub('Can ', '')
      puts new_description
      permission.update description: new_description
    end
  end
end
