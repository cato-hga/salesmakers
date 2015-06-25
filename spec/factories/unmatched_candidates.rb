# == Schema Information
#
# Table name: unmatched_candidates
#
#  id         :integer          not null, primary key
#  last_name  :string           not null
#  first_name :string           not null
#  email      :string           not null
#  score      :float            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do

  factory :unmatched_candidate do
    last_name 'Candidate'
    first_name 'Unmatched'
    email 'ummatched@test.com'
    score '82.34'
  end
end
