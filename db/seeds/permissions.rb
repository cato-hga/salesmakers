puts "Creating permissions"

Permission.destroy_all
PermissionGroup.destroy_all

pos_admin = Position.find_by_name 'System Administrator'
pos_vrrvp = Position.find_by_name 'Vonage Retail Regional Vice President'
pos_vrrm = Position.find_by_name 'Vonage Retail Regional Manager'
pos_vrasm = Position.find_by_name 'Vonage Retail Area Sales Manager'
pos_vrtm = Position.find_by_name 'Vonage Retail Territory Manager'
pos_vrss = Position.find_by_name 'Vonage Retail Sales Specialist'

pos_vervp = Position.find_by_name 'Vonage Event Regional Vice President'
pos_verm = Position.find_by_name 'Vonage Event Regional Manager'
pos_veasm = Position.find_by_name 'Vonage Event Area Sales Manager'
pos_vetl = Position.find_by_name 'Vonage Event Team Leader'
pos_velit = Position.find_by_name 'Vonage Event Leader in Training'
pos_vess = Position.find_by_name 'Vonage Event Sales Specialist'

pos_srrvp = Position.find_by_name 'Sprint Retail Regional Vice President'
pos_srrm = Position.find_by_name 'Sprint Retail Regional Manager'
pos_srasm = Position.find_by_name 'Sprint Retail Area Sales Manager'
pos_srtm = Position.find_by_name 'Sprint Retail Sales Director'
pos_srss = Position.find_by_name 'Sprint Retail Sales Specialist'

pos_rsrrvp = Position.find_by_name 'Rosetta Stone Retail Regional Vice President'
pos_rsrrm = Position.find_by_name 'Rosetta Stone Retail Regional Manager'
pos_rsrtm = Position.find_by_name 'Rosetta Stone Retail Territory Manager'
pos_rsrss = Position.find_by_name 'Rosetta Stone Retail Sales Specialist'

pos_uf = Position.find_by_name 'Unclassified Field Employee'
pos_uc = Position.find_by_name 'Unclassified HQ Employee'

pos_td = Position.find_by_name 'Training Director'
pos_t = Position.find_by_name 'Trainer'

pos_advd = Position.find_by_name 'Advocate Director'
pos_advs = Position.find_by_name 'Advocate Supervisor'
pos_adv = Position.find_by_name 'Advocate'
pos_rccd = Position.find_by_name 'Recruiting Call Center Director'
pos_rccr = Position.find_by_name 'Recruiting Call Center Representative'

pos_ssd = Position.find_by_name 'Senior Software Developer'
pos_sd = Position.find_by_name 'Software Developer'
pos_itd = Position.find_by_name 'Information Technology Director'
pos_itst = Position.find_by_name 'Information Technology Support Technician'

pos_od = Position.find_by_name 'Operations Director'
pos_oc = Position.find_by_name 'Operations Coordinator'
pos_ic = Position.find_by_name 'Inventory Coordinator'
pos_rc = Position.find_by_name 'Reporting Coordinator'

pos_fa = Position.find_by_name 'Finance Administrator'
pos_cont = Position.find_by_name 'Controller'
pos_acc = Position.find_by_name 'Accountant'

pos_md = Position.find_by_name 'Marketing Director'

pos_qad = Position.find_by_name 'Quality Assurance Director'
pos_qaa = Position.find_by_name 'Quality Assurance Administrator'

pos_ceo = Position.find_by_name 'Chief Executive Officer'
pos_coo = Position.find_by_name 'Chief Operations Officer'
pos_cfo = Position.find_by_name 'Chief Financial Officer'
pos_vps = Position.find_by_name 'Vice President of Sales'
pos_ea = Position.find_by_name 'Executive Assistant'

pos_pd = Position.find_by_name 'Payroll Director'
pos_pa = Position.find_by_name 'Payroll Administrator'

pos_hras = Position.find_by_name 'Human Resources Director'
pos_hra = Position.find_by_name 'Human Resources Administrator'

#Define
all_positions = [
    pos_admin,
    pos_vrrvp,
    pos_vrrm,
    pos_vrasm,
    pos_vrtm,
    pos_vrss,
    pos_vervp,
    pos_verm,
    pos_veasm,
    pos_vetl,
    pos_velit,
    pos_vess,
    pos_srrvp,
    pos_srrm,
    pos_srasm,
    pos_srtm,
    pos_srss,
    pos_rsrrvp,
    pos_rsrrm,
    pos_rsrtm,
    pos_rsrss,
    pos_uf,
    pos_uc,
    pos_td,
    pos_t,
    pos_advd,
    pos_advs,
    pos_adv,
    pos_rccd,
    pos_rccr,
    pos_ssd,
    pos_sd,
    pos_itd,
    pos_itst,
    pos_od,
    pos_oc,
    pos_ic,
    pos_rc,
    pos_fa,
    pos_cont,
    pos_acc,
    pos_md,
    pos_qad,
    pos_qaa,
    pos_ceo,
    pos_coo,
    pos_cfo,
    pos_vps,
    pos_ea,
    pos_pd,
    pos_pa,
    pos_hras,
    pos_hra
]

hq_positions = Position.where hq: true

ops_and_execs_positions = [
    pos_admin,
    pos_ceo,
    pos_coo,
    pos_cfo,
    pos_vps,
    pos_ea,
    pos_od,
    pos_oc,
    pos_ic,
    pos_rc,
    pos_qad,
    pos_qaa,
    pos_ssd,
    pos_sd,
    pos_itd
]

not_reps_positions = [
    pos_admin,
    pos_vrrvp,
    pos_vrrm,
    pos_vrasm,
    pos_vrtm,
    pos_vervp,
    pos_verm,
    pos_veasm,
    pos_vetl,
    pos_velit,
    pos_srrvp,
    pos_srrm,
    pos_srasm,
    pos_srtm,
    pos_rsrrvp,
    pos_rsrrm,
    pos_rsrtm,
    pos_uc,
    pos_td,
    pos_t,
    pos_advd,
    pos_advs,
    pos_adv,
    pos_rccd,
    pos_rccr,
    pos_ssd,
    pos_sd,
    pos_itd,
    pos_itst,
    pos_od,
    pos_oc,
    pos_ic,
    pos_rc,
    pos_fa,
    pos_cont,
    pos_acc,
    pos_md,
    pos_qad,
    pos_qaa,
    pos_ceo,
    pos_coo,
    pos_cfo,
    pos_vps,
    pos_ea,
    pos_pd,
    pos_pa,
    pos_hras,
    pos_hra
]

pg_people = PermissionGroup.create name: 'People'
areas_and_locations = PermissionGroup.create name: 'Areas and Locations'
clients_and_projects = PermissionGroup.create name: 'Clients and Projects'
departments_and_positions = PermissionGroup.create name: 'Departments and Positions'
widgets_permission_group = PermissionGroup.create name: 'Widgets'
audit_permission_group = PermissionGroup.create name: 'Audit'
profiles_permission_group = PermissionGroup.create name: 'Profiles'
q_and_a_permission_group = PermissionGroup.create name: 'Questions and Answers'
posts_permission_group = PermissionGroup.create name: 'Posts and Posting'
poll_questions_permission_group = PermissionGroup.create name: 'Poll Questions'

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

log_entry_index = Permission.create key: 'log_entry_index',
                                    description: 'can view logs',
                                    permission_group: audit_permission_group

poll_question_manage = Permission.create key: 'poll_question_manage',
                                         description: 'can manage poll questions',
                                         permission_group: poll_questions_permission_group

poll_question_show = Permission.create key: 'poll_question_show',
                                       description: 'can view all poll question results',
                                       permission_group: poll_questions_permission_group

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

blog_post_index = Permission.create key: 'blog_post_index',
                                    description: 'can view list of blog posts',
                                    permission_group: posts_permission_group

question_index = Permission.create key: 'question_index',
                                   description: 'can view list of questions',
                                   permission_group: q_and_a_permission_group

profile_update_others = Permission.create key: 'profile_update_others',
                                          description: 'can update profiles of others',
                                          permission_group: profiles_permission_group

profile_update = Permission.create key: 'profile_update',
                                   description: 'can update own profile',
                                   permission_group: profiles_permission_group

person_update_own_basic = Permission.create key: 'person_update_own_basic',
                                            description: 'can update own basic information',
                                            permission_group: profiles_permission_group

wall_show_all_walls = Permission.create key: 'wall_show_all_walls',
                                        description: 'can see all walls',
                                        permission_group: posts_permission_group

wall_post_promote = Permission.create key: 'wall_post_promote',
                                      description: "can change wall post's posted wall",
                                      permission_group: posts_permission_group

#TODO: Give some permission to update others

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
  position.permissions << blog_post_index
  position.permissions << question_index
  position.permissions << profile_update
  position.permissions << person_update_own_basic

end

for position in [pos_admin, pos_ssd, pos_sd, pos_itd, pos_itst, pos_od, pos_oc] do
  position.permissions << area_type_index
end

for position in not_reps_positions do
  position.permissions << wall_post_promote
end

for position in ops_and_execs_positions do
  position.permissions << client_index
  position.permissions << profile_update_others
  position.permissions << wall_show_all_walls
  position.permissions << poll_question_manage
  position.permissions << poll_question_show
end

for position in [pos_admin, pos_ssd, pos_sd, pos_itd, pos_itst] do
  position.permissions << department_index
  position.permissions << position_index
  position.permissions << log_entry_index
  position.permissions << profile_update_others
end

pos_md.permissions << poll_question_manage
pos_md.permissions << poll_question_show
