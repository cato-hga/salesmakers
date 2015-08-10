# == Schema Information
#
# Table name: candidate_denial_reasons
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :candidate_denial_reason do
    name 'Test Reason'
  end

end
