# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :medium, :class => 'Media' do
    mediable_id 1
    mediable_type "MyString"
  end
end
