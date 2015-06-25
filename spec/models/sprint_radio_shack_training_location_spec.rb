# == Schema Information
#
# Table name: sprint_radio_shack_training_locations
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string           not null
#  room       :string           not null
#  latitude   :float
#  longitude  :float
#  virtual    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SprintRadioShackTrainingLocation, :type => :model do

  describe 'validations' do
    let(:location) { build :sprint_radio_shack_training_location }
    it 'requires a name' do
      location.name = nil
      expect(location).not_to be_valid
    end
    it 'requires a virtual choice' do
      location.virtual = nil
      expect(location).not_to be_valid
    end
    it 'requires a room' do
      location.room = nil
      expect(location).not_to be_valid
    end
  end

  describe 'geocoding' do
    let(:location) { build :sprint_radio_shack_training_location, virtual: false }
    let(:saved_location) { create :sprint_radio_shack_training_location }
    let(:virtual_location) { create :sprint_radio_shack_training_location, virtual: true }
    let(:address) { 'Los Angeles, LA' }
    before(:each) do
      Geocoder.configure(lookup: :test)
      Geocoder::Lookup::Test.add_stub(
          "New York, NY", [
                            {
                                'latitude' => 40.7143528,
                                'longitude' => -74.0059731,
                                'address' => 'New York, NY, USA',
                                'state' => 'New York',
                                'state_code' => 'NY',
                                'country' => 'United States',
                                'country_code' => 'US'
                            }
                        ]
      )
      Geocoder::Lookup::Test.add_stub(
          "Los Angeles, LA", [
                               {
                                   'latitude' => 41.7143528,
                                   'longitude' => -75.0059731,
                                   'address' => 'Los Angeles, USA',
                                   'state' => 'New York',
                                   'state_code' => 'NY',
                                   'country' => 'United States',
                                   'country_code' => 'US'
                               }
                           ]
      )
    end

    it 'geocodes on production' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
      expect(location.latitude).to be_nil
      expect(location.longitude).to be_nil
      location.save
      expect(location.latitude).to eq(40.7143528)
      expect(location.longitude).to eq(-74.0059731)
    end

    it 'does not geocode when not on production' do
      expect(location.latitude).to be_nil
      expect(location.longitude).to be_nil
      location.save
      expect(location.latitude).to be_nil
      expect(location.longitude).to be_nil
    end

    it 'only geocodes when the address changes' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
      expect(saved_location.latitude).to eq(40.7143528)
      expect(saved_location.longitude).to eq(-74.0059731)
      saved_location.save
      expect(saved_location.latitude).to eq(40.7143528)
      expect(saved_location.longitude).to eq(-74.0059731)
      saved_location.update address: address
      saved_location.save
      expect(saved_location.latitude).to eq(41.7143528)
      expect(saved_location.longitude).to eq(-75.0059731)
    end

    it 'does not geocode virtual locations' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
      expect(virtual_location.latitude).to be_nil
      expect(virtual_location.longitude).to be_nil
      virtual_location.save
      expect(virtual_location.latitude).to be_nil
      expect(virtual_location.longitude).to be_nil
    end


  end
end
