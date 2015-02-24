FactoryGirl.define do

  factory :changelog_entry do
    heading 'New Feature'
    description 'This is a brand new feature that we just released.'
    released Time.now - 8.hours
  end

end