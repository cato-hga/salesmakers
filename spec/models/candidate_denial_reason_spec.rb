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

RSpec.describe CandidateDenialReason, :type => :model do

  describe 'validations' do
    let(:reason) { build :candidate_denial_reason }
    it 'requires a name' do
      reason.name = nil
      expect(reason).not_to be_valid
    end
    it 'requires an active Y/N' do
      reason.active = nil
      expect(reason).not_to be_valid
    end
  end
end
