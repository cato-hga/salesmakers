# FactoryGirl.define do
#
#   factory :information_technology_department, class: Department do
#     name 'Information Technology'
#     corporate true
#   end
#
#   factory :administrator_position, class: Position do
#     name 'System Administrator'
#     leadership true
#     all_field_visibility true
#     all_corporate_visibility true
#     association :department, factory: :information_technology_department
#     field false
#     hq true
#   end
#
#   factory :administrator_person, class: Person do
#     first_name 'System'
#     last_name 'Administrator'
#     display_name 'System Administrator'
#     email 'retailingw@retaildoneright.com'
#     personal_email 'retailingw@retaildoneright.com'
#     association :position, factory: :administrator_position
#     connect_user_id '2C908AA22CBD1292012CBD1735100034'
#     mobile_phone '8005551212'
#   end
#
# end