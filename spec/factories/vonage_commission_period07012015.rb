FactoryGirl.define do

  factory :vonage_commission_period07012015 do
    name 'Check Date 2015-08-31'
    hps_start { Date.new(2015, 7, 1) }
    hps_end { Date.new(2015, 7, 31) }
    cutoff { DateTime.new(2015, 8, 21, 4, 0, 0) }
  end

end