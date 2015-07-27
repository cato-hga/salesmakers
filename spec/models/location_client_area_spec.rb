# == Schema Information
#
# Table name: location_client_areas
#
#  id             :integer          not null, primary key
#  location_id    :integer          not null
#  client_area_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

describe LocationClientArea do
  subject { build :location_area }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it 'requires an area' do
    subject.area = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow duplicates' do
    subject.save
    duplicate = subject.dup
    expect(duplicate).not_to be_valid
  end
end
