class Position < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5 }
  validates :department, presence: true

  belongs_to :department
  has_many :people
  has_and_belongs_to_many :permissions

  def self.return_from_connect_user(connect_user)
    pos_uf = Position.find_by_name 'Unclassified Field Employee'
    pos_uc = Position.find_by_name 'Unclassified Corporate Employee'
    pos_adv = Position.find_by_name 'Advocate'
    pos_advs = Position.find_by_name 'Advocate Supervisor'
    pos_advd = Position.find_by_name 'Advocate Director'
    pos_hra = Position.find_by_name 'HR Administrator'
    pos_hras = Position.find_by_name 'HR Administrator Supervisor'
    pos_vrrvp = Position.find_by_name 'Vonage Retail Regional Vice President'
    pos_vervp = Position.find_by_name 'Vonage Event Regional Vice President'
    pos_vrrm = Position.find_by_name 'Vonage Retail Regional Manager'
    pos_verm = Position.find_by_name 'Vonage Event Regional Manager'
    pos_srrm = Position.find_by_name 'Sprint Retail Regional Manager'
    pos_vrasm = Position.find_by_name 'Vonage Retail Area Sales Manager'
    pos_veasm = Position.find_by_name 'Vonage Event Area Sales Manager'
    pos_vrtm = Position.find_by_name 'Vonage Retail Territory Manager'
    pos_vetl = Position.find_by_name 'Vonage Event Team Leader'
    pos_srtm = Position.find_by_name 'Sprint Retail Territory Manager'
    pos_vrss = Position.find_by_name 'Vonage Retail Sales Specialist'
    pos_vess = Position.find_by_name 'Vonage Event Sales Specialist'
    pos_srss = Position.find_by_name 'Sprint Retail Sales Specialist'
    connect_user_region = connect_user.region
    area_name = self.clean_area_name connect_user_region
    connect_user_project = (connect_user_region) ? connect_user_region.project : nil
    
    return pos_uf unless area_name and connect_user_project
    # TODO: If Openbravo Role is Company Officer and retaildoneright.com, then user is corporate
    
    retail = connect_user_region.name.include? 'Retail'
    event = connect_user_region.name.include? 'Event'
    retail = true if not retail and not event

    return nil if not connect_user_project
    project_name = connect_user_project.name
    vonage = project_name == 'Vonage'
    sprint = project_name == 'Sprint'
    corporate = project_name == 'Corporate'
    
    recruit = area_name.downcase.include? 'recruit'
    advocate = area_name.downcase.include? 'advocate'
    leader = connect_user.leader?
    
    position = nil
    case connect_user_region.fast_type
      when 4
        if leader
          position = pos_vrtm if vonage and retail
          position = pos_vetl if vonage and event
          position = pos_srtm if sprint and retail
          position = pos_hras if corporate and recruit
          position = pos_advs if corporate and advocate
        else
          position = pos_vrss if vonage and retail
          position = pos_vess if vonage and event
          position = pos_srss if sprint and retail
          position = pos_hra if corporate and recruit
          position = pos_adv if corporate and advocate
        end
      when 3
        if leader
          position = pos_vrasm if vonage and retail
          position = pos_veasm if vonage and event
          position = pos_advd if corporate and recruit
        end
      when 2
        if leader
          position = pos_vrrm if vonage and retail
          position = pos_verm if vonage and event
          position = pos_srrm if sprint and retail
        end
      when 1
        if leader
          position = pos_vrrvp if vonage and retail
          position = pos_vervp if vonage and event
          #TODO Add sprint regional vp or whatever Brian is
        end
    end
    position
  end

  def self.clean_area_name(connect_region)
    return nil unless connect_region and connect_region.name
    area_name = connect_region.name

    area_name = area_name.gsub('Vonage Retail - ', '')
    area_name = area_name.gsub('Vonage Events - ', '')
    area_name = area_name.gsub('Sprint - ', '')
    area_name.gsub('Retail Team', 'Kiosk')
  end

end
