class SeedGiftCardOverridePermission < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.find_or_create_by name: 'Gift Cards'
    Permission.create key: 'gift_card_override_create',
                      description: 'generate override gift cards',
                      permission_group: permission_group
  end

  def down
    Permission.where(key: 'gift_card_override_create').destroy_all
  end
end
