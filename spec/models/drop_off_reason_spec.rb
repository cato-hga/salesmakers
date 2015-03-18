require 'rails_helper'

RSpec.describe DropOffReason, :type => :model do

  describe 'validations' do
    let(:reason) { build :drop_off_reason }
    it 'requires a name' do
      reason.name = nil
      expect(reason).not_to be_valid
    end
    it 'requires active y/n' do
      reason.active = nil
      expect(reason).not_to be_valid
    end
    it 'requires eligible y/n' do
      reason.eligible_for_reschedule = nil
      expect(reason).not_to be_valid
    end
  end
end
