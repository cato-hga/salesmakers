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

describe CandidateDrugTest do

  describe 'validations' do
    let(:drug_test) { build :candidate_drug_test }

    it 'requires a yes/no for scheduled' do
      drug_test.scheduled = nil
      expect(drug_test).not_to be_valid
    end
  end

end
