# == Schema Information
#
# Table name: area_types
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  project_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class AreaType < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }
  validates :project, presence: true

  belongs_to :project
  has_many :areas

  default_scope { order :name }

  strip_attributes

  def self.get_hash
    {
        at_vrr: AreaType.find_by(name: 'Vonage Region'),
        at_vrm: AreaType.find_by(name: 'Vonage Market'),
        at_vrt: AreaType.find_by(name: 'Vonage Territory'),
        at_ver: AreaType.find_by(name: 'Vonage Event Region'),
        at_vet: AreaType.find_by(name: 'Vonage Event Team'),
        at_srr: AreaType.find_by(name: 'Sprint Prepaid Region'),
        at_srt: AreaType.find_by(name: 'Sprint Prepaid Territory'),
        at_ccrr: AreaType.find_by(name: 'Comcast Retail Region'),
        at_ccrm: AreaType.find_by(name: 'Comcast Retail Market'),
        at_ccrt: AreaType.find_by(name: 'Comcast Retail Territory'),
        at_dtvrr: AreaType.find_by(name: 'DirecTV Retail Region'),
        at_dtvrm: AreaType.find_by(name: 'DirecTV Retail Market'),
        at_dtvrt: AreaType.find_by(name: 'DirecTV Retail Territory')
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
        AreaType.find_by(name: 'Vonage Region'),
        AreaType.find_by(name: 'Vonage Market'),
        AreaType.find_by(name: 'Vonage Territory'),
    ]
  end

  def self.sprint_array
    [
        nil,
        nil,
        AreaType.find_by(name: 'Sprint Prepaid Region'),
        AreaType.find_by(name: 'Sprint Prepaid Market'),
        AreaType.find_by(name: 'Sprint Prepaid Territory'),
    ]
  end

  def self.star_array
    [
        nil,
        nil,
        AreaType.find_by(name: 'STAR Region'),
        AreaType.find_by(name: 'STAR Market'),
        AreaType.find_by(name: 'STAR Territory'),
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

  def self.directv_array
    [
        nil,
        nil,
        AreaType.find_by(name: 'DirecTV Retail Region'),
        AreaType.find_by(name: 'DirecTV Retail Market'),
        AreaType.find_by(name: 'DirecTV Retail Territory')
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
      elsif projects_hash[:star]
        return AreaType.star_array[fast_type]
      elsif projects_hash[:directv]
        return AreaType.directv_array[fast_type]
      else # Vonage
        return AreaType.vonage_retail_array[fast_type]
      end
    end
  end
end
