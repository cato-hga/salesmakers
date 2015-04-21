FactoryGirl.define do

  factory :workmarket_attachment do
    workmarket_assignment
    filename 'foobar.jpg'
    url '/assets/123456.jpg'
    guid '12345'
  end
end