FactoryGirl.define do
  factory :training_class_type do
    association :project
    name 'Test Type'
  end

end
