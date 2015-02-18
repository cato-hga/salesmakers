require 'yaml'

class Position < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5 }
  validates :department, presence: true

  belongs_to :department
  has_many :people
  has_and_belongs_to_many :permissions

  #:nocov:
  def self.return_from_connect_user(connect_user)
    hardcoded_position = get_hardcoded_position(connect_user)
    return hardcoded_position if hardcoded_position
    project_name = get_project_name(connect_user)
    event = event?(connect_user)
    leader = connect_user.leader?
    fast_type = connect_user.fast_type
    position = find_position(project_name, fast_type, event, leader)
    position = position_with_name(find_hq_position(connect_user, fast_type, leader)) if project_name == 'Corporate'
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
    area_name = area_name.gsub('Vonage Events - ', '')
    area_name = area_name.gsub('Sprint - ', '')
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
    connect_user_region = connect_user.region
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
    return find_hq_position_from_department('specialists', fast_type, leader) if andc.include? 'specialists'
    return find_hq_position_from_department('recruit', fast_type, leader) if andc.include? 'recruit'
    return find_hq_position_from_department('advocate', fast_type, leader) if andc.include? 'advocate'
    return find_hq_position_from_department('human', fast_type, leader) if andc.include? 'human'
    return find_hq_position_from_department('training', fast_type, leader) if andc.include? 'training'
    return find_hq_position_from_department('technology', fast_type, leader) if andc.include? 'technology'
    return find_hq_position_from_department('operations', fast_type, leader) if andc.include? 'operations'
    return find_hq_position_from_department('accounting', fast_type, leader) if andc.include? 'accounting'
    nil
  end

  def self.find_hq_position_from_department(department, fast_type, leader)
    positions = YAML.load_file('config/positions.yml')['Corporate']
    department_positions = positions[department] || return
    fast_type_positions = department_positions[fast_type] || return
    leader ? fast_type_positions['leader'] : fast_type_positions['not_leader']
  end
end