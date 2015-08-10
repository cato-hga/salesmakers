# == Schema Information
#
# Table name: candidate_sources
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
