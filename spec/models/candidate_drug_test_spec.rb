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

require 'rails_helper'

RSpec.describe CandidateDrugTest, :type => :model do

  describe 'validations' do
    let(:drug_test) { create :candidate_drug_test }
    it 'requires a yes/no for scheduled' do
      drug_test.scheduled = nil
      expect(drug_test).not_to be_valid
    end
    it 'requires a candidate' do
      drug_test.candidate_id = nil
      expect(drug_test).not_to be_valid
    end
  end
end
