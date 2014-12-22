require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Line, :type => :model do

  it { should ensure_length_of(:identifier).is_at_least(10) }
  it { should validate_presence_of(:contract_end_date) }
  it { should validate_presence_of(:technology_service_provider) }

  describe 'uniqueness validations' do
    it 'should validate uniqueness of identifier' do
      create :line
      line = build :line
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