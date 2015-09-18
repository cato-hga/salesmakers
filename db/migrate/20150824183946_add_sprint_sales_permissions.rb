class AddSprintSalesPermissions < ActiveRecord::Migration
  def change
    group = PermissionGroup.find_or_create_by name: 'Sprint'
    permission = Permission.create key: 'sprint_sale_create',
                                   permission_group: group,
                                   description: 'Can enter a sprint sale'

    srssd = Position.find_or_create_by name: 'Sprint RadioShack Sales Director'
    srs = Position.find_or_create_by name: 'Sprint RadioShack SalesMaker'
    srasm = Position.find_or_create_by name: 'Sprint Retail Area Sales Manager'
    srrm = Position.find_or_create_by name: 'Sprint Retail Regional Manager'
    srrvp = Position.find_or_create_by name: 'Sprint Retail Regional Vice President'
    srsd = Position.find_or_create_by name: 'Sprint Retail Sales Director'
    srss = Position.find_or_create_by name: 'Sprint Retail Sales Specialist'

    srssd.permissions << permission
    srs.permissions << permission
    srasm.permissions << permission
    srrm.permissions << permission
    srrvp.permissions << permission
    srsd.permissions << permission
    srss.permissions << permission
  end
end
