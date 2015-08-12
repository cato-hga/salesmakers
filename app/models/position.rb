# == Schema Information
#
# Table name: positions
#
#  id                       :integer          not null, primary key
#  name                     :string           not null
#  leadership               :boolean          not null
#  all_field_visibility     :boolean          not null
#  all_corporate_visibility :boolean          not null
#  department_id            :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  field                    :boolean
#  hq                       :boolean
#  twilio_number            :string
#

require 'yaml'

class Position < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 4 }
  validates :department, presence: true

  belongs_to :department
  has_many :people
  has_and_belongs_to_many :permissions
  has_many :log_entries, as: :trackable, dependent: :destroy
  has_many :log_entries, as: :referenceable, dependent: :destroy


  default_scope { order :name }

  #:nocov:
  def self.return_from_connect_user(connect_user)
    hardcoded_position = get_hardcoded_position(connect_user)
    return hardcoded_position if hardcoded_position
    project_name = get_project_name(connect_user)
    position = position_with_name(find_hq_position(connect_user, connect_user.fast_type, connect_user.leader?)) if project_name == 'Corporate'
    return position if position
    return position_with_name('Advocate') if connect_user.username and
        connect_user.username.include?('hireretailpros.com')
    position = find_position project_name,
                             connect_user.fast_type,
                             event?(connect_user),
                             connect_user.leader?
    position = position_with_name(find_hq_position(connect_user, connect_user.fast_type, connect_user.leader?)) if project_name == 'Corporate'
    position = position_with_name('Unclassified Field Employee') unless position
    return position_with_name('Unclassified Field Employee') if unclassified_field?(project_name, connect_user) and not position
    return position_with_name('Unclassified HQ Employee') if unclassified_corporate?(project_name, connect_user) and not position
    position
  end

  def self.clean_area_name(connect_region)
    return nil unless connect_region and connect_region.name
    area_name = connect_region.name

    area_name = area_name.gsub('Vonage Retail - ', '')
    area_name = area_name.gsub('Comcast - ', '')
    area_name = area_name.gsub('DirecTV - ', '')
    area_name = area_name.gsub('Vonage Events - ', '')
    area_name = area_name.gsub('Sprint - ', '')
    area_name = area_name.gsub('Sprint Prepaid - ', '')
    area_name = area_name.gsub('Sprint Postpaid - ', '')
    area_name.gsub('Retail Team', 'Kiosk')
  end

  def self.get_hardcoded_position(connect_user)
    hardcoded_positions = YAML.load_file('config/hardcoded_positions.yml')
    position_name = hardcoded_positions[connect_user.username] || return
    Position.find_by name: position_name
  end

  def self.get_project_name(connect_user)
    connect_user_region = connect_user.region
    connect_user_project = (connect_user_region) ? connect_user_region.project : nil
    return nil unless connect_user_project
    connect_user_project.name
  end

  def self.unclassified_field?(project_name, connect_user)
    connect_user_region = connect_user.region
    area_name = self.clean_area_name connect_user_region

    not area_name and not project_name and
        not connect_user.username.include? '@retaildoneright.com'
  end

  def self.unclassified_corporate?(project_name, connect_user)
    (project_name == 'Corporate' or not project_name) and
        connect_user.username.include? '@retaildoneright.com'
  end

  def self.position_with_name(name)
    Position.find_by name: name
  end

  def self.retail?(connect_user_region)
    connect_user_region.name.include? 'Retail' or
        connect_user_region.name.include? 'Sprint' or
        connect_user_region.name.include? 'Comcast'
  end

  def self.event?(connect_user)
    connect_user_region = connect_user.region || return
    connect_user_region.name.include? 'Event'
  end

  def self.find_position(project_name, fast_type, event, leader)
    positions = YAML.load_file('config/positions.yml')
    project = positions[project_name] || return
    fast_type = project[fast_type] || return
    retail_or_event = event ? fast_type['Event'] : fast_type['Retail']
    return unless retail_or_event
    leader_or_not = leader ? retail_or_event['leader'] : retail_or_event['not_leader']
    return unless leader_or_not
    position_with_name(leader_or_not)
  end

  def self.find_hq_position(connect_user, fast_type, leader)
    connect_user_region = connect_user.region
    area_name = self.clean_area_name connect_user_region
    andc = area_name.downcase
    lookup_table = {
        'specialists' => 'specialists',
        'salesmakers support' => 'smsupport',
        'recruit' => 'recruit',
        'advocate' => 'advocate',
        'human' => 'human',
        'training' => 'training',
        'technology' => 'technology',
        'operations' => 'operations',
        'accounting' => 'accounting'

    }
    for lookup in lookup_table do
      return find_hq_position_from_department(lookup[1], fast_type, leader) if andc.include? lookup[0]
    end
    nil
  end

  def self.find_hq_position_from_department(department, fast_type, leader)
    positions = YAML.load_file('config/positions.yml')['Corporate']
    department_positions = positions[department] || return
    fast_type_positions = department_positions[fast_type] || return
    leader ? fast_type_positions['leader'] : fast_type_positions['not_leader']
  end
end
