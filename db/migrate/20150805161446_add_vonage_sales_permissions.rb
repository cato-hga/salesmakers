class AddVonageSalesPermissions < ActiveRecord::Migration
  def change
    group = PermissionGroup.create name: 'Vonage'
    permission = Permission.create key: 'vonage_sale_create',
                                   permission_group: group,
                                   description: 'Can enter Vonage sale'


    esm = Position.find_or_create_by name: "Vonage Event Area Sales Manager"
    elt = Position.find_or_create_by name: "Vonage Event Leader in Training"
    erm = Position.find_or_create_by name: "Vonage Event Regional Manager"
    ess = Position.find_or_create_by name: "Vonage Event Sales Specialist"
    etl = Position.find_or_create_by name: "Vonage Event Team Leader"
    asm = Position.find_or_create_by name: "Vonage Area Sales Manager"
    rrm = Position.find_or_create_by name: "Vonage Regional Manager"
    rss = Position.find_or_create_by name: "Vonage Sales Specialist"
    rtm = Position.find_or_create_by name: "Vonage Territory Manager"

    esm.permissions << permission
    elt.permissions << permission
    erm.permissions << permission
    ess.permissions << permission
    etl.permissions << permission
    asm.permissions << permission
    rrm.permissions << permission
    rss.permissions << permission
    rtm.permissions << permission
  end
end
