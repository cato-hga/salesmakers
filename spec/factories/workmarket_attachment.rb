FactoryGirl.define do

  factory :workmarket_attachment do
    workmarket_assignment
    filename 'foobar.jpg'
    url '/assets/123456.jpg'
  end
end