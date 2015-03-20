require 'rails_helper'

RSpec.describe CandidateSchedulingDismissal, :type => :model do

  describe 'validations' do
    let(:dismissal) { build :candidate_scheduling_dismissal }
    it 'requires a comment' do
      dismissal.comment = nil
      expect(dismissal).not_to be_valid
    end
  end
end
