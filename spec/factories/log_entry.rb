FactoryGirl.define do

  factory :log_entry do
    person
    action 'create'
    trackable { create :person }
  end
end