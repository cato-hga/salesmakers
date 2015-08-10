# == Schema Information
#
# Table name: client_area_types
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  project_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class ClientAreaType < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }
  validates :project, presence: true

  belongs_to :project
  has_many :client_areas

  default_scope { order :name }

  def self.get_hash
    {
        at_vrr: ClientAreaType.find_by(name: 'Vonage Retail Region'),
        at_vrm: ClientAreaType.find_by(name: 'Vonage Retail Market'),
        at_vrt: ClientAreaType.find_by(name: 'Vonage Retail Territory'),
        at_ver: ClientAreaType.find_by(name: 'Vonage Event Region'),
        at_vet: ClientAreaType.find_by(name: 'Vonage Event Team'),
        at_srr: ClientAreaType.find_by(name: 'Sprint Retail Region'),
        at_srt: ClientAreaType.find_by(name: 'Sprint Retail Territory'),
        at_ccrr: ClientAreaType.find_by(name: 'Comcast Retail Region'),
        at_ccrm: ClientAreaType.find_by(name: 'Comcast Retail Market'),
        at_ccrt: ClientAreaType.find_by(name: 'Comcast Retail Territory'),
        at_dtvrr: ClientAreaType.find_by(name: 'DirecTV Retail Region'),
        at_dtvrm: ClientAreaType.find_by(name: 'DirecTV Retail Market'),
        at_dtvrt: ClientAreaType.find_by(name: 'DirecTV Retail Territory')
    }
  end

  def self.vonage_events_array
    [
        nil,
        nil,
        ClientAreaType.find_by(name: 'Vonage Event Region'),
        nil,
        ClientAreaType.find_by(name: 'Vonage Event Team'),
    ]
  end

  def self.vonage_retail_array
    [
        nil,
        nil,
        ClientAreaType.find_by(name: 'Vonage Retail Region'),
        ClientAreaType.find_by(name: 'Vonage Retail Market'),
        ClientAreaType.find_by(name: 'Vonage Retail Territory'),
    ]
  end

  def self.sprint_array
    [
        nil,
        nil,
        ClientAreaType.find_by(name: 'Sprint Retail Region'),
        ClientAreaType.find_by(name: 'Sprint Retail Market'),
        ClientAreaType.find_by(name: 'Sprint Retail Territory'),
    ]
  end

  def self.sprint_postpaid_array
    [
        nil,
        nil,
        ClientAreaType.find_by(name: 'Sprint Postpaid Region'),
        ClientAreaType.find_by(name: 'Sprint Postpaid Market'),
        ClientAreaType.find_by(name: 'Sprint Postpaid Territory'),
    ]
  end

  def self.comcast_array
    [
        nil,
        nil,
        ClientAreaType.find_by(name: 'Comcast Retail Region'),
        ClientAreaType.find_by(name: 'Comcast Retail Market'),
        ClientAreaType.find_by(name: 'Comcast Retail Territory')
    ]
  end

  def self.directv_array
    [
        nil,
        nil,
        ClientAreaType.find_by(name: 'DirecTV Retail Region'),
        ClientAreaType.find_by(name: 'DirecTV Retail Market'),
        ClientAreaType.find_by(name: 'DirecTV Retail Territory')
    ]
  end

  def self.determine_from_connect(connect_user, projects_hash, is_event)
    return nil unless connect_user and connect_user.region and projects_hash
    fast_type = connect_user.region.fast_type
    if is_event
      return ClientAreaType.vonage_events_array[fast_type]
    else
      if projects_hash[:comcast]
        return ClientAreaType.comcast_array[fast_type]
      elsif projects_hash[:sprint]
        return ClientAreaType.sprint_array[fast_type]
      elsif projects_hash[:sprint_postpaid]
        return ClientAreaType.sprint_postpaid_array[fast_type]
      elsif projects_hash[:directv]
        return ClientAreaType.directv_array[fast_type]
      else # Vonage Retail
        return ClientAreaType.vonage_retail_array[fast_type]
      end
    end
  end
end
