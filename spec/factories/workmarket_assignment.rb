FactoryGirl.define do

  factory :workmarket_assignment do
    project
    json '{}'
    workmarket_assignment_num '12345'
    title 'Workmarket Assignment Title'
    worker_name 'Worker Bee'
    worker_email 'worker@bee.com'
    cost 15
    started DateTime.now - 2.days
    ended DateTime.now - 2.days + 4.hours
    workmarket_location_num '1234'
  end

end