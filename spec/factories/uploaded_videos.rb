# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :uploaded_video do
    url 'https://www.youtube.com/watch?v=IBYfA3zTxFE'
    person
  end
end
