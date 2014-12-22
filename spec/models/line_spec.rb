require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Line, :type => :model do

  it { should ensure_length_of(:identifier).is_equal_to(10) }
  it { should validate_presence_of(:contract_end_date) }
  it { should validate_presence_of(:technology_service_provider) }

  describe 'uniqueness validations' do
    it 'should validate uniqueness of identifier' do
      create :line
      line = build :line
      expect(line).not_to be_valid
    end

  end

end