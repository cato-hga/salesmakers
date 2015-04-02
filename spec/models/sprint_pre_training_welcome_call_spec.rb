require 'rails_helper'

RSpec.describe SprintPreTrainingWelcomeCall, :type => :model do
  let(:call) { build :sprint_pre_training_welcome_call }

  describe 'validations' do
    it 'requires a candidate' do
      call.candidate = nil
      expect(call).not_to be_valid
    end
    it 'requires a cloud reviewed' do
      call.cloud_reviewed = nil
      expect(call).not_to be_valid
    end
    it 'requires a cloud confirmation' do
      call.cloud_confirmed = nil
      expect(call).not_to be_valid
    end
    it 'requires a group_me reviewed' do
      call.group_me_reviewed = nil
      expect(call).not_to be_valid
    end
    it 'requires a group_me confirmation' do
      call.group_me_confirmed = nil
      expect(call).not_to be_valid
    end
    it 'requires a epay reviewed' do
      call.epay_reviewed = nil
      expect(call).not_to be_valid
    end
    it 'requires a epay confirmation' do
      call.epay_confirmed = nil
      expect(call).not_to be_valid
    end
    it 'requires a still able to attend' do
      call.still_able_to_attend = nil
      expect(call).not_to be_valid
    end
  end

  describe '#confirmed?' do
    it 'returns true if all confirms and reviews are true' do
      call.cloud_reviewed = false
      expect(call.complete?).to eq(false)
      call.cloud_reviewed = true
      call.cloud_confirmed = true
      call.group_me_reviewed = true
      call.group_me_confirmed = true
      call.epay_reviewed = true
      call.epay_confirmed = true
      expect(call.complete?).to eq(true)
    end
  end
end