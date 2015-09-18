FactoryGirl.define do

  factory :attachment do
    association :attachable, factory: :candidate
    name 'Test Attachment'
    attachment_uid '12345'
    attachment_name '12345.pdf'
    person
  end

end