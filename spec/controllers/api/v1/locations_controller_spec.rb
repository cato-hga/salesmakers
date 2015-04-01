require 'rails_helper'

describe API::V1::LocationsController do
  let!(:location_area) {
    create :location_area,
           target_head_count: 2,
           location: location
  }
  let(:location) {
    create :location,
           latitude: 17.9857925,
           longitude: -66.3914388
  }
  let(:result) {
    [
        OpenStruct.new(data: {
                           "geometry" => {
                               "location" => {
                                   "lat" => 17.975792,
                                   "lng" => -66.3814388
                               }
                           }
                       })
    ]
  }

  before do
    allow(Geocoder).to receive(:search).and_return(result)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("dualbrain",
                                                                                                       "l3f7h3m15ph3r3")
  end

  describe 'with a correct zip' do
    before { get :nearby_zip, zip: '33701', format: :json }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'returns the nearby location(s)' do
      expect(response.body).to eq([CandidateLocation.new(location_area)].to_json)
    end
  end

  describe 'without a correct zip' do
    before { get :nearby_zip, zip: '223', format: :json }

    it 'does not return a success status' do
      expect(response).not_to be_success
    end

    it 'returns errors' do
      expect(response.body).to include('"errors"')
    end
  end
end