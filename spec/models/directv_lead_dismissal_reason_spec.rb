require 'rails_helper'

RSpec.describe DirecTVLeadDismissalReason, :type => :model do


  describe 'validations' do
    let(:reason) { build :directv_lead_dismissal_reason }
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