# == Schema Information
#
# Table name: historical_location_areas
#
#  id                        :integer          not null, primary key
#  historical_location_id    :integer          not null
#  historical_area_id        :integer          not null
#  current_head_count        :integer          default(0), not null
#  potential_candidate_count :integer          default(0), not null
#  target_head_count         :integer          default(0), not null
#  active                    :boolean          default(TRUE), not null
#  hourly_rate               :float
#  offer_extended_count      :integer          default(1), not null
#  outsourced                :boolean
#  launch_group              :integer
#  distance_to_cor           :float
#  priority                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  date                      :date             not null
#

require 'rails_helper'

describe HistoricalLocationArea do
  subject { build :historical_location_area }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it 'requires a location' do
    subject.historical_location = nil
    expect(subject).not_to be_valid
  end

  it 'requires an area' do
    subject.historical_area = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow duplicates' do
    subject.save
    duplicate = subject.dup
    expect(duplicate).not_to be_valid
  end
end
