# == Schema Information
#
# Table name: lines
#
#  id                             :integer          not null, primary key
#  identifier                     :string           not null
#  contract_end_date              :date             not null
#  technology_service_provider_id :integer          not null
#  created_at                     :datetime
#  updated_at                     :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

describe Line do

  describe 'uniqueness validations' do
    it 'should validate uniqueness of identifier' do
      create :line
      line = build :line
      line.identifier = Line.first.identifier
      expect(line).not_to be_valid
    end

  end

  describe '#active?' do
    let(:line) { create :line }
    let(:active_state) { create :line_state, name: 'Active', locked: true }

    it 'returns true if line has active state' do
      line.line_states << active_state
      line.reload
      expect(line.active?).to be_truthy
    end

    it 'returns false if line does not have the active state' do
      expect(line.active?).to be_falsey
    end
  end

end
