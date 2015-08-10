class SeedDirectvProjectAndAreaTypes < ActiveRecord::Migration
  def self.up
    directv_client = Client.create name: 'DirecTV'
    directv_department = Department.create name: 'DirecTV Retail Sales',
                                           corporate: false
    directv_retail = Project.create name: 'DirecTV Retail',
                                    client: directv_client
    AreaType.create name: 'DirecTV Retail Region',
                    project: directv_retail
    AreaType.create name: 'DirecTV Retail Territory',
                    project: directv_retail
    dtvrrvp = Position.create name: 'DirecTV Retail Regional Vice President',
                              leadership: true,
                              all_field_visibility: true,
                              all_corporate_visibility: true,
                              department_id: directv_department.id,
                              field: true,
                              hq: false
    dtvrrm = Position.create name: 'DirecTV Retail Regional Manager',
                             leadership: true,
                             all_field_visibility: false,
                             all_corporate_visibility: false,
                             department_id: directv_department.id,
                             field: true,
                             hq: false
    dtvrtm = Position.create name: 'DirecTV Retail Territory Manager',
                             leadership: true,
                             all_field_visibility: false,
                             all_corporate_visibility: false,
                             department_id: directv_department.id,
                             field: true,
                             hq: false
    dtvrss = Position.create name: 'DirecTV Retail Sales Specialist',
                             leadership: false,
                             all_field_visibility: false,
                             all_corporate_visibility: false,
                             department_id: directv_department.id,
                             field: true,
                             hq: false
    for permission in get_permissions do
      dtvrss.permissions << permission
      dtvrtm.permissions << permission
      dtvrrm.permissions << permission
      dtvrrvp.permissions << permission
    end
    person_index = Permission.find_by key: 'person_index'
    wall_post_promote = Permission.find_by key: 'person_index'
    dtvrtm.permissions << person_index
    dtvrrm.permissions << person_index
    dtvrrvp.permissions << person_index
    dtvrtm.permissions << wall_post_promote
    dtvrrm.permissions << wall_post_promote
    dtvrrvp.permissions << wall_post_promote
  end

  def self.down
    client = Client.find_by name: 'DirecTV'
    return unless client
    for project in client.projects
      for area in project.areas do
        area.person_areas.destroy_all
      end
      project.areas.destroy_all
      project.destroy
    end
    client.destroy
    department = Department.find_by name: 'DirecTV Retail Sales'
    return unless department
    department.positions.destroy_all
    department.destroy
  end

  def get_permissions
    permissions = []
    permissions << Permission.find_by(key: 'area_index')
    permissions << Permission.find_by(key: 'blog_post_index')
    permissions << Permission.find_by(key: 'question_index')
    permissions << Permission.find_by(key: 'profile_update')
    permissions << Permission.find_by(key: 'person_update_own_basic')
    permissions << Permission.find_by(key: 'widget_hours')
    permissions << Permission.find_by(key: 'widget_tickets')
    permissions << Permission.find_by(key: 'widget_social')
    permissions << Permission.find_by(key: 'widget_alerts')
    permissions << Permission.find_by(key: 'widget_image_gallery')
    permissions << Permission.find_by(key: 'widget_inventory')
    permissions << Permission.find_by(key: 'widget_staffing')
    permissions << Permission.find_by(key: 'widget_gaming')
    permissions << Permission.find_by(key: 'widget_commissions')
    permissions << Permission.find_by(key: 'widget_training')
    permissions << Permission.find_by(key: 'widget_gift_cards')
    permissions << Permission.find_by(key: 'widget_pnl')
    permissions << Permission.find_by(key: 'widget_hps')
    permissions << Permission.find_by(key: 'widget_assets')
    permissions << Permission.find_by(key: 'widget_groupme_slider')
    permissions.compact
  end
end
