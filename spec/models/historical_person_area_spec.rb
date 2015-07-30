# == Schema Information
#
# Table name: person_areas
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  area_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  manages    :boolean          default(FALSE), not null
#

require 'rails_helper'

describe HistoricalPersonArea do
  subject { build :historical_person_area }

  it 'is correct with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it 'requires an historical person' do
    subject.historical_person = nil
    expect(subject).not_to be_valid
  end

  it 'requires an historical area' do
    subject.historical_area = nil
    expect(subject).not_to be_valid
  end
end
