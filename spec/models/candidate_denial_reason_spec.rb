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

require 'rails_helper'

describe CandidateDenialReason do

  describe 'validations' do
    let(:reason) { build :candidate_denial_reason }

    it 'requires an active Y/N' do
      reason.active = nil
      expect(reason).not_to be_valid
    end
  end
end
