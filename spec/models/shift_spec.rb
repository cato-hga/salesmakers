# == Schema Information
#
# Table name: shifts
#
#  id          :integer          not null, primary key
#  person_id   :integer          not null
#  location_id :integer
#  date        :date             not null
#  hours       :decimal(, )      not null
#  break_hours :decimal(, )      default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Shift do
  subject { build :shift }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it 'requires hours' do
    subject.hours = nil
    expect(subject).not_to be_valid
  end
end
