puts "Creating permissions"

Permission.destroy_all
PermissionGroup.destroy_all

pos_admin = Position.find_by_name 'System Administrator'
pos_ssd = Position.find_by_name 'Senior Software Developer'
pos_uf = Position.find_by_name 'Unclassified Field Employee'
pos_uc = Position.find_by_name 'Unclassified Corporate Employee'
pos_adv = Position.find_by_name 'Advocate'
pos_advs = Position.find_by_name 'Advocate Supervisor'
pos_advd = Position.find_by_name 'Advocate Director'
pos_hra = Position.find_by_name 'HR Administrator'
pos_hras = Position.find_by_name 'HR Administrator Supervisor'
pos_vrrvp = Position.find_by_name 'Vonage Retail Regional Vice President'
pos_vervp = Position.find_by_name 'Vonage Event Regional Vice President'
pos_vrrm = Position.find_by_name 'Vonage Retail Regional Manager'
pos_verm = Position.find_by_name 'Vonage Event Regional Manager'
pos_srrm = Position.find_by_name 'Sprint Retail Regional Manager'
pos_vrasm = Position.find_by_name 'Vonage Retail Area Sales Manager'
pos_veasm = Position.find_by_name 'Vonage Event Area Sales Manager'
pos_vrtm = Position.find_by_name 'Vonage Retail Territory Manager'
pos_vetl = Position.find_by_name 'Vonage Event Team Leader'
pos_srtm = Position.find_by_name 'Sprint Retail Territory Manager'
pos_vrss = Position.find_by_name 'Vonage Retail Sales Specialist'
pos_vess = Position.find_by_name 'Vonage Event Sales Specialist'
pos_srss = Position.find_by_name 'Sprint Retail Sales Specialist'

#Define
all_positions = [
    pos_admin, pos_ssd, pos_uf, pos_uc, pos_adv, pos_advs, pos_advd, pos_hra, pos_hras, pos_vrrvp, pos_vervp,
    pos_vrrm, pos_verm, pos_srrm, pos_vrasm, pos_veasm, pos_vrtm, pos_vetl, pos_srtm, pos_vrss, pos_vess, pos_srss
]
hq_positions = Position.where hq: true

ops_and_execs_positions = [
    pos_admin, pos_ssd
]

pg_people = PermissionGroup.create name: 'People'
areas_and_locations = PermissionGroup.create name: 'Areas and Locations'
clients_and_projects = PermissionGroup.create name: 'Clients and Projects'
departments_and_positions = PermissionGroup.create name: 'Departments and Positions'
widgets_permission_group = PermissionGroup.create name: 'Widgets'

person_index = Permission.create key: 'person_index',
                                 description: 'can view list of people',
                                 permission_group: pg_people


area_type_index = Permission.create key: 'area_type_index',
                                    description: 'can view list of area types',
                                    permission_group: areas_and_locations

area_index = Permission.create key: 'area_index',
                               description: 'can view list of areas',
                               permission_group: areas_and_locations


client_index = Permission.create key: 'client_index',
                                 description: 'can view list of clients',
                                 permission_group: clients_and_projects

department_index = Permission.create key: 'department_index',
                                     description: 'can view list of departments',
                                     permission_group: departments_and_positions

position_index = Permission.create key: 'position_index',
                                   description: 'can view list of positions',
                                   permission_group: departments_and_positions

widgets = [
    'sales',
    'hours',
    'tickets',
    'social',
    'alerts',
    'image_gallery',
    'inventory',
    'staffing',
    'gaming',
    'commissions',
    'training',
    'gift_cards',
    'pnl',
    'hps',
    'assets',
    'groupme_slider'
]

for widget in widgets do
  widget_permission = Permission.create key: 'widget_' + widget,
                                        description: 'can view list the' + widget + ' widget',
                                        permission_group: widgets_permission_group
  for position in all_positions do
    position.permissions << widget_permission
  end
end

for position in all_positions do
  position.permissions << person_index
  position.permissions << area_index
end

for position in hq_positions do
  position.permissions << area_type_index
end

for position in ops_and_execs_positions do
  position.permissions << client_index
end

pos_admin.permissions << department_index
pos_ssd.permissions << department_index
pos_admin.permissions << position_index
pos_ssd.permissions << position_index


