class AreaType < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 3 }
  validates :project, presence: true

  belongs_to :project
  has_many :areas

  default_scope { order :name }

  def self.get_hash
    {
        at_vrr: AreaType.find_by(name: 'Vonage Retail Region'),
        at_vrm: AreaType.find_by(name: 'Vonage Retail Market'),
        at_vrt: AreaType.find_by(name: 'Vonage Retail Territory'),
        at_ver: AreaType.find_by(name: 'Vonage Event Region'),
        at_vet: AreaType.find_by(name: 'Vonage Event Team'),
        at_srr: AreaType.find_by(name: 'Sprint Retail Region'),
        at_srt: AreaType.find_by(name: 'Sprint Retail Territory'),
        at_ccrr: AreaType.find_by(name: 'Comcast Retail Region'),
        at_ccrm: AreaType.find_by(name: 'Comcast Retail Market'),
        at_ccrt: AreaType.find_by(name: 'Comcast Retail Territory')
    }
  end

  def self.vonage_events_array
    [
        nil,
        nil,
        AreaType.find_by(name: 'Vonage Event Region'),
        nil,
        AreaType.find_by(name: 'Vonage Event Team'),
    ]
  end

  def self.vonage_retail_array
    [
        nil,
        nil,
        AreaType.find_by(name: 'Vonage Retail Region'),
        AreaType.find_by(name: 'Vonage Retail Market'),
        AreaType.find_by(name: 'Vonage Retail Territory'),
    ]
  end

  def self.sprint_array
    [
        nil,
        nil,
        AreaType.find_by(name: 'Sprint Retail Region'),
        nil,
        AreaType.find_by(name: 'Sprint Retail Territory'),
    ]
  end

  def self.comcast_array
    [
        nil,
        nil,
        AreaType.find_by(name: 'Comcast Retail Region'),
        AreaType.find_by(name: 'Comcast Retail Market'),
        AreaType.find_by(name: 'Comcast Retail Territory')
    ]
  end

  def self.determine_from_connect(connect_user, projects_hash, is_event)
    return nil unless connect_user and connect_user.region and projects_hash
    fast_type = connect_user.region.fast_type
    if is_event
      return AreaType.vonage_events_array[fast_type]
    else
      if projects_hash[:comcast]
        return AreaType.comcast_array[fast_type]
      elsif projects_hash[:sprint]
        return AreaType.sprint_array[fast_type]
      else # Vonage Retail
        return AreaType.vonage_retail_array[fast_type]
      end
    end
  end
end
