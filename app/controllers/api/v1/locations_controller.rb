class API::V1::LocationsController < API::BaseController

  def nearby_zip
    zip = params[:zip]
    unless zip and /\A[0-9]{5}\z/.match(zip)
      respond_with error_json('zip', 'ZIP must be exactly 5 digits'), status: :bad_request and return
    end
    lat_long = get_lat_long zip
    unless lat_long
      respond_with error_json('zip', 'Could not determine latitude and longitude from provided ZIP code'), status: :not_found and return
    end
    respond_with get_nearby(lat_long)
  end

  private

  def get_lat_long(zip)
    results = Geocoder.search zip
    if results.empty?
      sleep 0.5
      results = Geocoder.search zip
    end
    return if results.empty? or
        not results[0].data or
        not results[0].data['geometry'] or
        not results[0].data['geometry']['location']
    location = results[0].data['geometry']['location']
    [location['lat'], location['lng']]
  end

  def get_nearby(lat_long)
    all_locations = Location.
        joins(:location_areas).
        where('location_areas.target_head_count > 0')
    return [] if all_locations.count(:all) < 1
    all_locations = Location.where("locations.id IN (#{all_locations.map(&:id).join(',')})")
    locations = all_locations.near(lat_long, 30)
    if not locations or locations.count(:all) < 5
      locations = all_locations.near(lat_long, 500).first(5)
    end
    CandidateLocation.from_locations(locations)
  end

  def error_json(id, title)
    {
        'errors' => [
            {
                'id' => id,
                'title' => title
            }
        ]
    }
  end

end