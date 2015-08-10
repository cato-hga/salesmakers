# == Schema Information
#
# Table name: candidate_drug_tests
#
#  id           :integer          not null, primary key
#  scheduled    :boolean          default(FALSE), not null
#  test_date    :datetime
#  comments     :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  candidate_id :integer
#

FactoryGirl.define do
  factory :candidate_drug_test do
    scheduled false
    association :candidate
  end

end
