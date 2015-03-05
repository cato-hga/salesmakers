require 'csv'
require 'clusterer'

class LocationClusterer

  def self.get_clusterer
    data_points = []
    channel = Channel.find_by name: 'Radio Shack'
    for location in channel.locations.where('latitude IS NOT NULL') do
      data_points << DataPoint.new(latitude: location.latitude, longitude: location.longitude)
    end
    Algorithms::KMeans::Clusterer.new data_points: data_points, num_clusters: 250
  end

  def self.cluster(clusterer)
    CSV.open('clusters.csv', 'w') do |csv|
      csv << ['cluster_number', 'store_num', 'store_address', 'latitude', 'longitude', 'center_store_number', 'center_store_address', 'center_latitude', 'center_longitude', 'distance_to_center']
      for cluster in clusterer.clusters do
        count = 0 unless count
        count += 1
        near_center = Location.near(cluster.centroid, 500).first
        center_store_number = near_center ? near_center.store_number : nil
        center_address = near_center ? near_center.address : nil
        for data_point in cluster.data_points do
          near_point = Location.near(data_point).first
          point_store_number = near_point ? near_point.store_number : nil
          point_address = near_point ? near_point.address : nil
          csv << [
              count.to_s,
              point_store_number,
              point_address,
              data_point.latitude,
              data_point.longitude,
              center_store_number,
              center_address,
              cluster.centroid.latitude,
              cluster.centroid.longitude,
              Geocoder::Calculations.distance_between(near_point, near_center)
          ]
        end
      end
    end
  end

end