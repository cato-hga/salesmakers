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

describe Location do
  subject { build :location }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a store_number' do
    subject.store_number = nil
    expect(subject).not_to be_valid
  end

  it 'requires a city' do
    subject.city = nil
    expect(subject).not_to be_valid
  end

  it 'requires a city at least 2 characters long' do
    subject.city = 'a'
    expect(subject).not_to be_valid
  end

  it 'requires a state' do
    subject.state = nil
    expect(subject).not_to be_valid
  end

  it 'requires the state be valid' do
    subject.state = 'FF'
    expect(subject).not_to be_valid
  end

  it 'requires a channel' do
    subject.channel = nil
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

  it 'responds to location_client_areas' do
    expect(subject).to respond_to(:location_client_areas)
  end

  describe 'LocationAreas' do
    let(:project) { create :project }
    let(:second_project) { create :project }
    let(:area) { create :area, project: project }
    let(:second_area) { create :area, project: second_project }
    let!(:location_area) { create :location_area, location: subject, area: area }
    let!(:second_location_area) { create :location_area, location: subject, area: second_area }

    it 'determines the location_area for a location and project' do
      location_areas = LocationArea.for_project_and_location(project, subject)
      expect(location_areas.count).to eq(1)
      expect(location_areas).to include(location_area)
      expect(location_areas).not_to include(second_location_area)
    end
  end

  it 'responds to latitude and longitude' do
    expect(subject).to respond_to(:latitude)
    expect(subject).to respond_to(:longitude)
  end

end