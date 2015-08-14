require 'rails_helper'

describe HistoricalLocationArea do
  subject { build :historical_location_area }

  it 'does not allow duplicates' do
    subject.save
    duplicate = subject.dup
    expect(duplicate).not_to be_valid
  end
end