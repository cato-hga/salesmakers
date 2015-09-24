require 'rails_helper'

describe API::V1::LocationsController do
  let(:project) { create :project, name: 'STAR' }
  let(:area) { create :area, project: project }
  let!(:location_area) {
    create :location_area,
           priority: 1,
           target_head_count: 2,
           location: location,
           area: area
  }
  let(:location) {
    create :location,
           latitude: 17.9857925,
           longitude: -66.3914388
  }
  let(:outside_project) { create :project }
  let(:outside_area) { create :area, project: outside_project }
  let!(:other_project_location_area) {
    create :location_area,
           area: outside_area,
           location: other_project_location,
           target_head_count: 2
  }
  let(:other_project_location) {
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
    before do
      allow(controller).to receive(:get_lat_long).with('33701').and_return([17.9857925, -66.3914388])
      get :nearby_zip_for_project,
          zip: '33701',
          project_id: location_area.area.project_id,
          format: :json
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'returns the nearby location(s)' do
      expect(response.body).to eq([CandidateLocation.new(location_area)].to_json)
    end
  end

  describe 'without a correct zip' do
    before do
      get :nearby_zip_for_project,
          zip: '223',
          project_id: location_area.area.project_id,
          format: :json
    end

    it 'does not return a success status' do
      expect(response).not_to be_success
    end

    it 'returns errors' do
      expect(response.body).to include('"errors"')
    end
  end
end
