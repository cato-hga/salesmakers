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
