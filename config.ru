# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

if defined?(PhusionPassenger)
  PhusionPassenger.require_passenger_lib 'rack/out_of_band_gc'
  # Trigger out-of-band GC every 5 requests.
  use PhusionPassenger::Rack::OutOfBandGc, 5
end

run Rails.application