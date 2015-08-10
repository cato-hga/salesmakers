class AddComcastSeeds < ActiveRecord::Migration
  def self.up
    comcast_retail_sales = Department.find_or_create_by name: 'Comcast Retail Sales',
                                                           corporate: false

    positions = [{ name: 'Comcast Retail Regional Vice President',
                   leadership: true,
                   all_field_visibility: false,
                   all_corporate_visibility: false,
                   department_id: comcast_retail_sales.id,
                   field: true,
                   hq: false  },
                 { name: 'Comcast Retail Territory Manager',
                   leadership: true,
                   all_field_visibility: false,
                   all_corporate_visibility: false,
                   department_id: comcast_retail_sales.id,
                   field: true,
                   hq: false  },
                 { name: 'Comcast Retail Sales Specialist',
                   leadership: false,
                   all_field_visibility: false,
                   all_corporate_visibility: false,
                   department_id: comcast_retail_sales.id,
                   field: true,
                   hq: false  }]

    for position in positions do
      Position.find_or_create_by position
    end

    pg_people = PermissionGroup.find_or_create_by name: 'People'
    areas_and_locations = PermissionGroup.find_or_create_by name: 'Areas and Locations'
    posts_permission_group = PermissionGroup.find_or_create_by name: 'Posts and Posting'
    q_and_a_permission_group = PermissionGroup.find_or_create_by name: 'Questions and Answers'
    profiles_permission_group = PermissionGroup.find_or_create_by name: 'Profiles'

    person_index = Permission.find_or_create_by key: 'person_index',
                                                description: 'can view list of people',
                                                permission_group: pg_people
    area_index = Permission.find_or_create_by key: 'area_index',
                                              description: 'can view list of areas',
                                              permission_group: areas_and_locations
    blog_post_index = Permission.find_or_create_by key: 'blog_post_index',
                                                   description: 'can view list of blog posts',
                                                   permission_group: posts_permission_group
    question_index = Permission.find_or_create_by key: 'question_index',
                                                  description: 'can view list of questions',
                                                  permission_group: q_and_a_permission_group
    profile_update = Permission.find_or_create_by key: 'profile_update',
                                                  description: 'can update own profile',
                                                  permission_group: profiles_permission_group
    person_update_own_basic = Permission.find_or_create_by key: 'person_update_own_basic',
                                                           description: 'can update own basic information',
                                                           permission_group: profiles_permission_group
    wall_post_promote = Permission.find_or_create_by key: 'wall_post_promote',
                                                     description: "can change wall post's posted wall",
                                                     permission_group: posts_permission_group

    pos_ccrrvp = Position.find_by_name 'Comcast Retail Regional Vice President'
    pos_ccrtm = Position.find_by_name 'Comcast Retail Territory Manager'
    pos_ccrss = Position.find_by_name 'Comcast Retail Sales Specialist'

    all_positions = [pos_ccrrvp, pos_ccrtm, pos_ccrss]
    not_reps_positions = [pos_ccrrvp, pos_ccrtm]

    for position in all_positions do
      position.permissions << person_index
      position.permissions << area_index
      position.permissions << blog_post_index
      position.permissions << question_index
      position.permissions << profile_update
      position.permissions << person_update_own_basic
    end

    for position in not_reps_positions do
      position.permissions << wall_post_promote
    end

    comcast = Client.find_or_create_by name: 'Comcast'
    comcast_retail = Project.find_or_create_by name: 'Comcast Retail',
                                               client: comcast
    ccrr = AreaType.find_or_create_by name: 'Comcast Retail Region',
                                      project: comcast_retail
    ccrm = AreaType.find_or_create_by name: 'Comcast Retail Market',
                                      project: comcast_retail
    ccrt = AreaType.find_or_create_by name: 'Comcast Retail Territory',
                                      project: comcast_retail

    ccr_connect = ConnectRegion.find_by_value 'Comcast Retail-1'
    ccrrs_connect = ccr_connect.children
    ccrrs_connect.each do |ccrr_connect|
      new_ccrr = Area.find_or_create_by name: ccrr_connect.name,
                                        area_type: ccrr,
                                        project: comcast_retail,
                                        connect_salesregion_id: ccrr_connect.c_salesregion_id,
                                        created_at: ccrr_connect.created,
                                        updated_at: ccrr_connect.updated
      ccrms_connect = ccrr_connect.children
      ccrms_connect.each do |ccrm_connect|
        new_ccrm = Area.find_or_initialize_by name: ccrm_connect.name,
                                          area_type: ccrm,
                                          project: comcast_retail,
                                          connect_salesregion_id: ccrm_connect.c_salesregion_id,

                                          created_at: ccrm_connect.created,
                                          updated_at: ccrm_connect.updated
        new_ccrm.save
        new_ccrm.parent = new_ccrr
        new_ccrm.save
        ccrts_connect = ccrm_connect.children
        ccrts_connect.each do |ccrt_connect|
          new_ccrt = Area.find_or_initialize_by name: ccrt_connect.name.gsub('Comcast - ', ''),
                                            area_type: ccrt,
                                            project: comcast_retail,
                                            connect_salesregion_id: ccrt_connect.c_salesregion_id,
                                            created_at: ccrt_connect.created,
                                            updated_at: ccrt_connect.updated
          new_ccrt.save
          new_ccrt.parent = new_ccrm
          new_ccrt.save
        end
      end
    end

  end

  def self.down
    pos_ccrrvp = Position.find_by_name 'Comcast Retail Regional Vice President'
    pos_ccrtm = Position.find_by_name 'Comcast Retail Territory Manager'
    pos_ccrss = Position.find_by_name 'Comcast Retail Sales Specialist'
    all_positions = [pos_ccrrvp, pos_ccrtm, pos_ccrss]
    all_positions.each do |pos|
      Permission.where(position: pos).destroy_all
    end
    comcast_retail_sales = Department.find_by name: 'Comcast Retail Sales'
    Position.where(department: comcast_retail_sales).destroy_all
    comcast_retail = Project.find_by name: 'Comcast Retail'
    Area.where(project: comcast_retail).destroy_all
    AreaType.where("name LIKE 'Comcast%'").destroy_all
    Project.where(name: 'Comcast Retail').destroy_all
    Client.where(name: 'Comcast').destroy_all
  end
end
