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

class CandidateDrugTest < ActiveRecord::Base

  validates :scheduled, inclusion: {in: [true, false]}
  validates :candidate_id, presence: true

  belongs_to :candidate

  def self.policy_class
    CandidatePolicy
  end
end
