# # Read about factories at https://github.com/thoughtbot/factory_girl
#
# FactoryGirl.define do
#   factory :wall_post do
#     publication
#     association :wall, factory: :person_wall
#     person
#   end
#
#   factory :it_wall_post, class: WallPost do
#     publication
#     association :wall, factory: :department_wall
#     person { Person.find_by display_name: 'System Administrator' }
#   end
#
#   factory :non_it_wall_post, class: WallPost do
#     association :publication, factory: :non_it_publication
#     association :wall, factory: :department_wall
#     person { Person.find_by display_name: 'System Administrator' }
#   end
# end