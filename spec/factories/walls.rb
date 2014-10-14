FactoryGirl.define do

  factory :person_wall, class: Wall do
    wallable { |w| w.association(:person) }
  end

  factory :department_wall, class: Wall do
    wallable { |w| w.association(:department) }
  end
end