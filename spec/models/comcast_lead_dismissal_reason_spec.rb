require 'rails_helper'

RSpec.describe ComcastLeadDismissalReason, :type => :model do


  describe 'validations' do
    let(:reason) { build :comcast_lead_dismissal_reason }
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