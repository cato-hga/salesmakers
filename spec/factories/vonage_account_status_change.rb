FactoryGirl.define do

  factory :vonage_account_status_change do
    mac '906EBB123456'
    account_start_date Date.yesterday
    status 0
  end
end