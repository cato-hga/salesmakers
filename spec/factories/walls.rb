FactoryGirl.define do

  factory :person_wall, class: Wall do
    wallable { |w| w.association(:person) }
  end

  factory :department_wall, class: Wall do
    wallable { |w| w.association(:department) }
  end

  factory :area_wall, class: Wall do
    wallable { |w| w.association(:area) }
  end

  factory :project_wall, class: Wall do
    wallable { |w| w.association(:project) }
  end

  factory :client_wall, class: Wall do
    wallable { |w| w.association(:client) }
  end
end