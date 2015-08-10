# == Schema Information
#
# Table name: candidate_reconciliations
#
#  id           :integer          not null, primary key
#  candidate_id :integer          not null
#  status       :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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
