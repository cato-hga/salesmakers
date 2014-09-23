# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :uploaded_image do
    image_uid "MyString"
    thumbnail_uid "MyString"
    preview_uid "MyString"
    large_uid "MyString"
    person_id 1
    caption "MyString"
    score 1
  end
end
