FactoryGirl.define do

  factory :device_note do
    device
    person
    note 'This is a note'
  end

end