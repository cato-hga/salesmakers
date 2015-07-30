# == Schema Information
#
# Table name: client_areas
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  client_area_type_id :integer          not null
#  ancestry            :string
#  created_at          :datetime
#  updated_at          :datetime
#  project_id          :integer          not null
#

require 'rails_helper'
require 'shoulda/matchers'

describe HistoricalClientArea do
  subject { build :historical_client_area }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it 'requires a name at least 3 characters long' do
    subject.name = 'aa'
    expect(subject).not_to be_valid
  end

  it 'requires a client_area_type' do
    subject.client_area_type = nil
    expect(subject).not_to be_valid
  end
end
