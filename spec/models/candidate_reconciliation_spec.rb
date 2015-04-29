require 'rails_helper'

RSpec.describe CandidateReconciliation, :type => :model do

  describe 'validations' do
    let(:recon) { create :candidate_reconciliation }
    it 'requires a candidate' do
      recon.candidate = nil
      expect(recon).not_to be_valid
    end

    it 'requires a status' do
      recon.status = nil
      expect(recon).not_to be_valid
    end
  end
end
