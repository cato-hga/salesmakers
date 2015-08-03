FactoryGirl.define do

  factory :vonage_paycheck do
    sequence(:name) { |n| "#{(Date.current.beginning_of_month - n.months).strftime('%Y-%m-%d')} through #{(Date.current.end_of_month - n.months).strftime('%Y-%m-%d')}"}
    # name '2015-02-01 through 2015-02-15'
    sequence(:wages_start) { |n| Date.current.beginning_of_month - n.months }
    sequence(:wages_end) { |n| Date.current.end_of_month - n.months }
    sequence(:commission_start) { |n| Date.current.beginning_of_month - n.months }
    sequence(:commission_end) { |n| Date.current.end_of_month - n.months }
    sequence(:cutoff) { |n| DateTime.now.end_of_month.end_of_day - n.months }
    # wages_start Date.new(2015, 2, 1)
    # wages_end Date.new(2015, 2, 15)
    # commission_start Date.new(2015, 1, 26)
    # commission_end Date.new(2015, 2, 8)
    # cutoff DateTime.new(2015, 2, 16, 14, 30, 0, '-5')
  end

  factory :another_vonage_paycheck, class: VonagePaycheck do
    name '2015-02-16 through 2015-02-28'
    wages_start Date.new(2015, 2, 16)
    wages_end Date.new(2015, 2, 28)
    commission_start Date.new(2015, 2, 9)
    commission_end Date.new(2015, 2, 22)
    cutoff DateTime.new(2015, 3, 1, 14, 30, 0, '-5')
  end
end