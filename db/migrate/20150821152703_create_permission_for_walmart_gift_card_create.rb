class CreatePermissionForWalmartGiftCardCreate < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.create name: 'Gift Cards'
    Permission.create key: 'walmart_gift_card_create', description: 'import Walmart gift cards', permission_group: permission_group
  end

  def down
    Permission.find_by(key: 'walmart_gift_card_create').destroy
    PermissionGroup.find_by(name: 'Gift Cards').destroy
  end
end
