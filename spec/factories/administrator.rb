FactoryGirl.define do

  factory :information_technology_department, class: Department do
    name 'Information Technology'
    corporate true
  end

  factory :administrator_position, class: Position do
    name 'System Administrator'
    leadership true
    all_field_visibility true
    all_corporate_visibility true
    association :department, factory: :information_technology_department
    field false
    hq true
  end

  factory :main_permission_group, class: PermissionGroup do
    name 'Main Group'
  end

  factory :main_permission, class: Permission do
    description 'Foobar this is a permission'
    association :permission_group, factory: :main_permission_group
  end

  factory :administrator_person, class: Person do
    first_name 'System'
    last_name 'Administrator'
    display_name 'System Administrator'
    email 'retailingw@retaildoneright.com'
    personal_email 'retailingw@retaildoneright.com'
    association :position, factory: :administrator_position
    connect_user_id '2C908AA22CBD1292012CBD1735100034'
    mobile_phone '8005551212'

    after(:create) do |person|
      permissions = Array.new
      permissions << create(:main_permission, key: 'area_type_index')
      permissions << create(:main_permission, key: 'wall_show_all_walls')
      permissions << create(:main_permission, key: 'blog_post_index')
      permissions << create(:main_permission, key: 'client_index')
      permissions << create(:main_permission, key: 'department_index')
      permissions << create(:main_permission, key: 'log_entry_index')
      permissions << create(:main_permission, key: 'medium_index')
      permissions << create(:main_permission, key: 'person_update_own_basic')
      permissions << create(:main_permission, key: 'poll_question_manage')
      permissions << create(:main_permission, key: 'poll_question_show')
      permissions << create(:main_permission, key: 'position_index')
      permissions << create(:main_permission, key: 'profile_update')
      permissions << create(:main_permission, key: 'wall_post_promote')
      for permission in permissions do
        person.position.permissions << permission
      end
    end
  end

end