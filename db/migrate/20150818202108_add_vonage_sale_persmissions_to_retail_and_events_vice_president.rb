class AddVonageSalePersmissionsToRetailAndEventsVicePresident < ActiveRecord::Migration
  def change
    group = PermissionGroup.create name: 'Vonage'
    permission = Permission.create key: 'vonage_sale_create',
                                   permission_group: group,
                                   description: 'Can enter Vonage sale'


    evp = Position.find_or_create_by name: "Vonage Event Regional Vice President"
    rvp = Position.find_or_create_by name: "Vonage Regional Vice President"

    evp.permissions << permission
    rvp.permissions << permission
  end
end
