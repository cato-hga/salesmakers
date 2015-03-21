require 'rails_helper'

RSpec.describe CandidateAvailability, :type => :model do

  describe 'validations' do
    let(:available) { build :candidate_availability }
    it 'requires a candidate' do
      available.candidate_id = nil
      expect(available).not_to be_valid
    end
    it 'requires at least one option selected' do
      available.monday_first = false
      expect(available).not_to be_valid
      available.tuesday_first = true
      expect(available).to be_valid
      available.tuesday_first = false
      expect(available).not_to be_valid
    end
  end
end
