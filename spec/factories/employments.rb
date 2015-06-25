# == Schema Information
#
# Table name: employments
#
#  id         :integer          not null, primary key
#  person_id  :integer
#  start      :date
#  end        :date
#  end_reason :string
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do

  factory :employment do
    start Time.now - 1.month
  end
end
