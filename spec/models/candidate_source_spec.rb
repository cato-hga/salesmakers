require 'rails_helper'

describe CandidateSource do

  let(:source) { build :candidate_source }
  describe 'validations' do
    it 'requires a name' do
      source.name = nil
      expect(source).not_to be_valid
    end
  end
end