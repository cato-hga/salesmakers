FactoryGirl.define do

  factory :workmarket_attachment do
    workmarket_assignment
    filename 'foobar.jpg'
    url 'https://www.workmarket.com/assets/123456.jpg'
  end
end