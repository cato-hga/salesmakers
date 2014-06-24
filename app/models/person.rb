class Person < ActiveRecord::Base
  before_validation :generate_display_name

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :display_name, presence: true, length: { minimum: 5 }
  validates :email, presence: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/ } #TODO Prompt for valid email
  validates :personal_email, presence: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/ } #TODO Prompt for valid email
  validates :position, presence: true


  belongs_to :position
  #TODO Why the hell does this need to be belongs_to instead of has_one?
  belongs_to :connect_user
  has_many :person_areas

  def create_from_connect_user(connect_user)

  end

  def import_position
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

    at_vrr = AreaType.find_by_name 'Vonage Retail Region'
    at_vrm = AreaType.find_by_name 'Vonage Retail Market'
    at_vrt = AreaType.find_by_name 'Vonage Retail Territory'
    at_ver = AreaType.find_by_name 'Vonage Event Region'
    at_vet = AreaType.find_by_name 'Vonage Event Team'
    at_srr = AreaType.find_by_name 'Sprint Retail Region'
    at_srt = AreaType.find_by_name 'Sprint Retail Territory'


    users_connect_region = self.connect_user.region
    if users_connect_region == nil
      self.update_attributes position_id: pos_uf
      return
    end
    area_name = users_connect_region.name
    area_name = area_name.gsub('Vonage Retail - ', '')
    area_name = area_name.gsub('Vonage Events - ', '')
    area_name = area_name.gsub('Sprint - ', '')
    area_name = area_name.gsub('Retail Team', 'Kiosk')
    users_project = users_connect_region.project
    if users_project == nil
      # TODO: If Openbravo Role is Company Officer and retaildoneright.com, then user is corporate
      self.update_attributes position_id: pos_uf
      return
    end
    retail = users_connect_region.name.include? 'Retail'
    event = users_connect_region.name.include? 'Event'
    retail = true if not retail and not event
    proj = users_project.name
    vonage = proj == 'Vonage'
    sprint = proj == 'Sprint'
    corporate = proj == 'Corporate'
    recruit = users_connect_region.name.downcase.include? 'recruit'
    advocate = users_connect_region.name.downcase.include? 'advocate'
    leader = self.connect_user.leader?
    PersonArea.where(person: self).destroy_all
    case users_connect_region.fast_type
      when 4
        if leader
          self.position_id = pos_vrtm.id if vonage and retail
          self.position_id = pos_vetl.id if vonage and event
          self.position_id = pos_srtm.id if sprint and retail
          self.position_id = pos_hras.id if corporate and recruit
          self.position_id = pos_advs.id if corporate and advocate
        else
          self.position_id = pos_vrss.id if vonage and retail
          self.position_id = pos_vess.id if vonage and event
          self.position_id = pos_srss.id if sprint and retail
          self.position_id = pos_hra.id if corporate and recruit
          self.position_id = pos_adv.id if corporate and advocate
        end
        area_type = at_vrt if vonage and retail
        area_type = at_vet if vonage and event
        area_type = at_srt if sprint and retail
      when 3
        if leader
          self.position_id = pos_vrasm.id if vonage and retail
          self.position_id = pos_veasm.id if vonage and event
          self.position_id = pos_advd.id if corporate and recruit
        end
        area_type = at_vrm if vonage and retail
      when 2
        if leader
          self.position_id = pos_vrrm.id if vonage and retail
          self.position_id = pos_verm.id if vonage and event
          self.position_id = pos_srrm.id if sprint and retail
        end
        area_type = at_vrr if vonage and retail
        area_type = at_ver if vonage and event
        area_type = at_srr if sprint and retail
      when 1
        if leader
          self.position_id = pos_vrrvp.id if vonage and retail
          self.position_id = pos_vervp.id if vonage and event
          #TODO Add sprint regional vp or whatever Brian is
        end
    end
    creator_connect_user = ConnectUser.find self.connect_user.createdby
    creator = Person.return_from_connect_user creator_connect_user if creator_connect_user.present?
    unless self.position_id.present?
      self.position_id = corporate ? pos_uc.id : pos_uf.id
    end
    # if creator.present? and creator.id.present?
    #   log_entry = LogEntry.create action: 'set_position',
    #                               trackable: self,
    #                               referenceable: self.position,
    #                               created_at: self.connect_user.created,
    #                               updated_at: self.connect_user.updated,
    #                               user_id: creator.id
    # end
    self.save
    return unless area_type.present?
    areas = Area.where(name: area_name, area_type: area_type)
    return unless areas.count > 0
    area = areas.first
    area.save
    person_area = self.person_areas.create area: area,
                                       manages: leader
    return unless person_area.present?
    return unless creator.present?
    # action = creator_connect_user.leader? ? 'assign_as_manager' : 'assign_as_employee'
    # log_entry = LogEntry.create action: action,
    #                             trackable: self,
    #                             referenceable: area,
    #                             created_at: self.connect_user.created,
    #                             updated_at: self.connect_user.updated,
    #                             user: creator
  end

  def self.return_from_connect_user(connect_user)
    # Set Person to nil in case of remnants of past calls.
    this_person = nil
    # Find the Person if there is one already in the DB
    this_person = self.find_by_email connect_user.username if connect_user.present?
    # If the ConnectUser exists but there isn't already already a
    # Person in the local DB, then...
    if connect_user.present? and not this_person.present?
      # Create the Person.
      this_person = self.create first_name: connect_user.firstname,
                              last_name: connect_user.lastname,
                              display_name: (connect_user.name) ? connect_user.name : [connect_user.firstname, connect_user.lastname].join(' '),
                              email: connect_user.username,
                              personal_email: (connect_user.description) ? connect_user.description : connect_user.email,
                              connect_user_id: connect_user.id,
                              active: (connect_user.isactive == 'Y') ? true : false
      this_person.import_position
      creator_connect_user = ConnectUser.find connect_user.createdby
      if creator_connect_user.present? and this_person.present? and this_person.id.present?
        if creator_connect_user.id == '0'
          creator = Person.find_by_email 'retailingw@retaildoneright.com'
        else
          creator = self.return_from_connect_user creator_connect_user
        end
        # if creator.present? and creator.id.present?
        #   log_entry = LogEntry.create action: 'create',
        #                               trackable: this_person,
        #                               created_at: connect_user.created,
        #                               updated_at: connect_user.updated,
        #                               user: creator
        # end
      end
    end
    # Return the local Person from the DB
    this_person
  end

  private

  def generate_display_name
    self.display_name = self.first_name + ' ' + self.last_name if self.display_name.blank?
  end
end
