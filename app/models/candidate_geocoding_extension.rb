module CandidateGeocodingExtension
  def self.included(klass)
    klass.extend ClassMethods
  end

  private

  def geocode_on_production
    return unless Rails.env.production? or Rails.env.staging?
    self.geocode
    if self.latitude and self.longitude
      time_zone_result = GoogleTimezone.fetch self.latitude, self.longitude || return
      self.time_zone = time_zone_result.time_zone_id
    end
  end

  def reverse_geocode_on_production
    return unless Rails.env.production?
    self.reverse_geocode
  end

  public

  module ClassMethods
    def geocoding_validations
      geocoded_by :zip
      reverse_geocoded_by :latitude, :longitude, &reverse_geocode_strategy

      after_validation :reverse_geocode_on_production,
                       if: ->(candidate) {
                         candidate.latitude.present? and candidate.latitude_changed?
                       }
      after_validation :geocode_on_production,
                       if: ->(candidate) {
                         candidate.zip.present? and candidate.zip_changed?
                       }
    end

    def reverse_geocode_strategy
      lambda do |obj, results|
        if geo = results.first
          if geo and geo.state_code and geo.state_code.length > 2
            obj.state = geo.country == 'Puerto Rico' ? 'PR' : {
                "Alabama" => "AL", "Alaska" => "AK", "Arizona" => "AZ",
                "Arkansas" => "AR", "California" => "CA",
                "Colorado" => "CO", "Connecticut" => "CT",
                "Delaware" => "DE", "Florida" => "FL", "Georgia" => "GA",
                "Hawaii" => "HI", "Idaho" => "ID", "Illinois" => "IL",
                "Indiana" => "IN", "Iowa" => "IA",
                "Kansas" => "KS", "Kentucky" => "KY", "Louisiana" => "LA",
                "Maine" => "ME", "Maryland" => "MD",
                "Massachusetts" => "MA", "Michigan" => "MI",
                "Minnesota" => "MN", "Mississippi" => "MS",
                "Missouri" => "MO",
                "Montana" => "MT", "Nebraska" => "NE", "Nevada" => "NV",
                "New Hampshire" => "NH", "New Jersey" => "NJ",
                "New Mexico" => "NM", "New York" => "NY",
                "North Carolina" => "NC", "North Dakota" => "ND",
                "Ohio" => "OH",
                "Oklahoma" => "OK", "Oregon" => "OR",
                "Pennsylvania" => "PA", "Puerto Rico" => "PR",
                "Rhode Island" => "RI",
                "South Carolina" => "SC", "South Dakota" => "SD",
                "Tennessee" => "TN", "Texas" => "TX", "Utah" => "UT",
                "Vermont" => "VT", "Virginia" => "VA", "Washington" => "WA",
                "West Virginia" => "WV", "Wisconsin" => "WI",
                "Wyoming" => "WY"
            }[geo.state_code]
          else
            obj.state = geo.state_code
          end
        end
      end
    end
  end
end