# == Schema Information
#
# Table name: locations
#
#  id                                      :integer          not null, primary key
#  display_name                            :string
#  store_number                            :string           not null
#  street_1                                :string
#  street_2                                :string
#  city                                    :string           not null
#  state                                   :string           not null
#  zip                                     :string
#  channel_id                              :integer          not null
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  latitude                                :float
#  longitude                               :float
#  sprint_radio_shack_training_location_id :integer
#  cost_center                             :string
#  mail_stop                               :string
#

require 'rails_helper'

describe HistoricalLocation do
  subject { build :historical_location }

  it 'requires the state be valid' do
    subject.state = 'FF'
    expect(subject).not_to be_valid
  end

  it 'responds to latitude and longitude' do
    expect(subject).to respond_to(:latitude)
    expect(subject).to respond_to(:longitude)
  end

  it 'responds to cost_center' do
    expect(subject).to respond_to(:cost_center)
  end

  it 'responds to mail_stop' do
    expect(subject).to respond_to(:mail_stop)
  end

  it 'responds to historical_location_client_areas' do
    expect(subject).to respond_to(:historical_location_client_areas)
  end
end