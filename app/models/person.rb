require 'validators/phone_number_validator'
class Person < ActiveRecord::Base
  include ActiveModel::Validations

  nilify_blanks

  before_validation :generate_display_name
  #after_save :create_profile
  #after_save :create_wall

  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }
  validates :display_name, length: { minimum: 5 }
  validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }, uniqueness: true
  validates :personal_email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }, allow_blank: true
  validates :connect_user_id, uniqueness: true, allow_nil: true
  validates_with PhoneNumberValidator

  belongs_to :position
  belongs_to :connect_user
  has_many :person_areas
  has_many :areas, through: :person_areas
  belongs_to :supervisor, class_name: 'Person'
  has_many :employees, class_name: 'Person', foreign_key: 'supervisor_id'
  has_many :device_deployments
  has_many :devices
  has_one :profile
  has_many :permissions, through: :position
  has_one :wall, as: :wallable
  has_one :group_me_user
  has_many :uploaded_images
  has_many :uploaded_videos
  has_many :blog_posts
  has_many :wall_posts
  has_many :questions
  has_many :answers
  has_many :answer_upvotes
  has_many :group_me_likes, through: :group_me_user
  has_many :group_me_posts
  has_many :employments
  has_many :day_sales_counts, as: :saleable
  has_many :sales_performance_ranks, as: :rankable
  has_many :person_addresses
  has_and_belongs_to_many :poll_question_choices

  has_many :to_sms_messages, class_name: 'SMSMessage', foreign_key: 'to_person_id'
  has_many :from_sms_messages, class_name: 'SMSMessage', foreign_key: 'from_person_id'
  has_many :communication_log_entries

  ransacker :mobile_phone_number, formatter: proc { |v| v.strip.gsub /[^0-9]/, '' } do |parent|
    parent.table[:mobile_phone]
  end

  scope :visible, ->(person = nil) {
    return Person.none unless person
    people = Array.new
    position = person.position

    return team_members unless position

    if position.all_field_visibility?
      people = people.concat Person.all_field_members
    end
    if position.all_corporate_visibility?
      people = people.concat Person.all_hq_members
    end
    if position.hq?
      people = people.concat person.department_members
    end

    people = people.concat person.team_members
    return Person.none if people.count < 1

    Person.where("\"people\".\"id\" IN (#{people.map(&:id).join(',')})")
  }

  default_scope { order :display_name }

  def display_name
    unless self[:display_name] and self[:display_name].length > 0
      return ''
    end
    NameCase(self[:display_name])
  end

  def team_members
    people = Array.new
    for person_area in self.person_areas do
      next unless person_area.area
      areas = person_area.area.subtree
      for area in areas do
        people = people.concat area.people.to_a
      end
    end
    people.flatten
  end

  def department_members
    return Person.none unless self.position and self.position.department
    self.position.department.people
  end

  def self.all_field_members
    positions = Position.where( field: true )
    Person.where( position: positions)
  end

  def self.all_hq_members
    positions = Position.where( hq: true )
    Person.where( position: positions )
  end

  def self.return_from_connect_user(connect_user)
    person = Person.find_by connect_user_id: connect_user.id
    return person if person
    email = connect_user.email
    first_name = connect_user.firstname
    last_name = connect_user.lastname
    display_name = connect_user.display_name
    personal_email = connect_user.personal_email
    active = connect_user.active?
    phone = connect_user.phone
    createdby = connect_user.createdby
    created = connect_user.created
    updated = connect_user.updated
    supervisor_id = connect_user.supervisor_id
    position = Position.return_from_connect_user connect_user
    person = Person.find_by_email email
    creator = createdby ? Person.find_by_connect_user_id(createdby) : nil
    supervisor = supervisor_id ? Person.find_by_connect_user_id(supervisor_id) : nil

    return person if person
    person = Person.new first_name: first_name,
                        last_name: last_name,
                        display_name: display_name,
                        email: email,
                        personal_email: personal_email,
                        connect_user_id: connect_user.id,
                        active: active,
                        mobile_phone: phone,
                        position: position,
                        supervisor: supervisor
    return nil unless person and person.save
    PersonArea.where(person: person).destroy_all
    LogEntry.person_onboarded_from_connect person, creator, created, updated
    LogEntry.position_set_from_connect person, creator, position, created, updated if position
    person.add_area_from_connect

    person
  end

  def department
    return nil unless self.position
    self.position.department
  end

  def name
    self.display_name
  end

  def termination_date_invalid?
    begin
      self.employments and
          self.employments.count and
          self.employments.count > 0 and
          self.employments.first.end and
          self.employments.first.end.strftime('%Y').to_i < 2008
    rescue
      return false
    end
  end

  def terminated?
    self.employments.count > 0 and self.employments.first.end
  end

  def mobile_phone?
    self.mobile_phone and self.mobile_phone != '8005551212'
  end

  def home_phone?
    self.home_phone and self.home_phone != '8005551212'
  end

  def office_phone?
    self.office_phone and self.office_phone != '8005551212'
  end

  # def social_name
  #   if self.profile.nickname? and not self.profile.nickname.blank?
  #     self.profile.nickname
  #   else
  #     self.display_name
  #   end
  # end

  #:nocov:
  def import_employment_from_connect
    return unless self.connect_user_id
    connect_user = self.connect_user
    bpartner = connect_user.connect_business_partner
    return unless bpartner
    salary_categories = bpartner.connect_business_partner_salary_categories
    return unless salary_categories
    employment_started = salary_categories.first
    return unless employment_started
    employment = Employment.new person: self,
                                start: employment_started.datefrom,
                                created_at: connect_user.created,
                                updated_at: employment_started.updated
    unless self.active?
      terminations = connect_user.connect_terminations
      ended = connect_user.updated.to_date
      terminated = ended
      ended = connect_user.lastcontact.to_date if connect_user.lastcontact
      reason = 'Not Recorded'
      if terminations and terminations.count > 0
        ended = terminations.first.last_day_worked
        terminated = terminations.first.created
        reason = terminations.first.connect_termination_reason.reason if terminations.first.connect_termination_reason
      end
      employment.end = ended
      employment.updated_at = terminated
      employment.end_reason = reason
    end
    employment.save
  end

  def show_details?(people)
    people and people.include?(self)
  end

  def hire_date
    if self.employments.count > 0
      self.employments.first.start
    else
      nil
    end
  end

  def term_date
    if self.termination_date_invalid?
      nil
    elsif self.terminated?
      self.employments.first.end
    else
      nil
    end
  end

  def position_name
    if self.position
      self.position.name
    else
      nil
    end
  end

  def supervisor_name
    if self.supervisor
      self.supervisor.display_name
    else
      nil
    end
  end

  def return_person_area_from_connect
    return nil unless self.connect_user_id
    connect_user = ConnectUser.find_by ad_user_id: self.connect_user_id
    return nil unless connect_user
    at_vrr = AreaType.find_by_name 'Vonage Retail Region'
    at_vrm = AreaType.find_by_name 'Vonage Retail Market'
    at_vrt = AreaType.find_by_name 'Vonage Retail Territory'
    at_ver = AreaType.find_by_name 'Vonage Event Region'
    at_vet = AreaType.find_by_name 'Vonage Event Team'
    at_srr = AreaType.find_by_name 'Sprint Retail Region'
    at_srt = AreaType.find_by_name 'Sprint Retail Territory'
    at_ccrr = AreaType.find_by_name 'Comcast Retail Region'
    at_ccrm = AreaType.find_by_name 'Comcast Retail Market'
    at_ccrt = AreaType.find_by_name 'Comcast Retail Territory'
    connect_user_region = connect_user.region
    area_name = Position.clean_area_name connect_user_region
    connect_user_project = (connect_user_region) ? connect_user_region.project : nil
    return nil unless connect_user_region and connect_user_project

    retail = connect_user_region.name.include? 'Retail'
    event = connect_user_region.name.include? 'Event'
    retail = true if not retail and not event

    project_name = connect_user_project.name
    vonage = project_name == 'Vonage'
    sprint = project_name == 'Sprint'
    comcast = project_name == 'Comcast'
    leader = connect_user.leader?

    area_type = nil
    case connect_user_region.fast_type
      when 4
        area_type = at_vrt if vonage and retail
        area_type = at_vet if vonage and event
        area_type = at_srt if sprint and retail
        area_type = at_ccrt if comcast and retail
      when 3
        area_type = at_vrm if vonage and retail
        area_type = at_ccrm if comcast and retail
      when 2
        area_type = at_vrr if vonage and retail
        area_type = at_ver if vonage and event
        area_type = at_srr if sprint and retail
        area_type = at_ccrr if comcast and retail
    end
    return nil unless area_type
    areas = Area.where(name: area_name, area_type: area_type)
    return nil unless areas.count > 0
    area = areas.first
    person_area = self.person_areas.new area: area,
                                        manages: leader
    person_area
  end

  def add_area_from_connect
    connect_user = ConnectUser.find_by ad_user_id: self.connect_user_id
    creator = Person.find_by_connect_user_id connect_user.createdby
    person_area = self.return_person_area_from_connect
    return unless person_area
    if person_area.save
      area = person_area.area
      leader = person_area.manages?
      return unless creator
      created_at = leader ? area.updated_at : connect_user.created
      if leader
        LogEntry.assign_as_manager_from_connect self, creator, person_area.area, created_at, created_at
      else
        LogEntry.assign_as_employee_from_connect self, creator, person_area.area, created_at, created_at
      end
    end
  end

  def separate_from_connect
    connect_user = get_connect_user
    return unless connect_user
    for subordinate in self.employees do
      subordinate_connect_user = subordinate.connect_user
      next unless subordinate_connect_user
      PersonUpdater.new(subordinate_connect_user).update
    end
    separator = connect_user.updater
    self.update(active: false, updated_at: connect_user.updated)
    updated_to_inactive = self.active? ? false : true
    return updated_to_inactive if self.employments.count < 1
    return if self.employments.count < 1
    employment = self.employments.first
    terminations = connect_user.connect_terminations
    ended = connect_user.updated.to_date
    ended = connect_user.lastcontact.to_date if connect_user.lastcontact
    reason = 'Not Recorded'
    if terminations and terminations.count > 0
      ended = terminations.first.last_day_worked
      reason = terminations.first.connect_termination_reason.reason if terminations.first.connect_termination_reason
    end
    employment.end = ended
    employment.end_reason = reason
    employment.save
    updated_to_inactive
  end

  def update_address_from_connect
    return unless has_address?
    connect_address = self.connect_user.
        connect_business_partner.
        connect_business_partner_locations.
        first.
        connect_location
    connect_state = connect_address.connect_state
    return unless connect_address and connect_state
    new_address = PersonAddress.new person: self,
                                    line_1: connect_address.address1,
                                    line_2: connect_address.address2,
                                    city: connect_address.city,
                                    state: connect_state.name,
                                    zip: connect_address.postal
    return unless new_address.valid?
    self.person_addresses.where(physical: true).destroy_all
    new_address.save
  end

  def has_address?
    return false unless self.connect_user
    bp = self.connect_user.connect_business_partner
    return false unless bp
    locations = bp.connect_business_partner_locations
    return false unless locations.count > 0
    connect_address = locations.first.connect_location
    return false unless connect_address
    state = connect_address.connect_state
    return false unless state
    true
  end

  def get_connect_user
    ConnectUser.find_by username: self.email
  end
  #:nocov:

  def separate
    self.update(active: false, updated_at: separated_at)
  end

  def log?(action, trackable, referenceable = nil, created_at = nil, updated_at = nil, comment = nil)
    return false unless self and self.id
    entry = LogEntry.new person: self,
                         action: action,
                         trackable: trackable,
                         referenceable: referenceable,
                         comment: comment
    entry.created_at = created_at if created_at
    entry.updated_at = updated_at if updated_at
    entry.save ? true : false
  end

  # def create_wall
  #   return if self.wall
  #   Wall.create wallable: self
  # end

  #:nocov:
  def self.update_from_connect(minutes)
    connect_users = ConnectUser.where('updated >= ?', Time.now - minutes.minutes + (Time.zone_offset(Time.zone.now.strftime('%Z')) / 60 / 60))
    for connect_user in connect_users do
      PersonUpdater.new(connect_user).update
    end
  end
  #:nocov:

  # def profile_avatar
  #   return unless profile
  #   profile.avatar
  # end
  #
  # def profile_avatar_url
  #   return unless profile_avatar
  #   profile_avatar.url
  # end
  #
  # def group_me_avatar_url
  #   return unless group_me_user
  #   group_me_user.avatar_url
  # end
  #
  # def default_wall
  #   if self.position.hq?
  #     Wall.find_by wallable: self.position.department
  #   elsif person_areas.count > 0
  #     Wall.find_by wallable: self.person_areas.first.area
  #   else
  #     Wall.find_by wallable: self
  #   end
  # end

  def related_log_entries
    LogEntry.for_person(self)
  end

  def sales_today
    return 0 unless self.connect_user_id
    if self.person_areas.count > 0 and
        (self.person_areas.first.area.project.name == 'Vonage Retail' or
            self.person_areas.first.area.project.name == 'Vonage Events')
      ConnectOrder.sales.today.where(salesrep_id: self.connect_user_id).count
    elsif self.person_areas.count > 0 and
        self.person_areas.first.area.project.name == 'Sprint Retail'
      ConnectSprintSale.today.where(ad_user_id: self.connect_user_id).count
    end
  end

  def sms_messages
    to_messages = self.to_sms_messages
    from_messages = self.from_sms_messages
    to_ids = to_messages.map(&:id).join(',')
    from_ids = from_messages.map(&:id).join(',')
    if to_ids.length > 0 and from_ids.length > 0
      ids = "#{to_ids},#{from_ids}"
    elsif to_ids.length > 0
      ids = to_ids
    elsif from_ids.length > 0
      ids = from_ids
    else
      ids = nil
    end
    if ids
      SMSMessage.where("id IN (#{ids})")
    else
      SMSMessage.none
    end
  end

  def locations
    all_locations = Array.new
    for person_area in self.person_areas do
      all_locations << person_area.area.all_locations
    end
    all_locations.flatten.uniq
  end

  def hq?
    self.position and self.position.hq?
  end

  def physical_address
    PersonAddress.get_physical(self)
  end

  def mailing_address
    address = PersonAddress.find_by person: self, physical: false
  end

  private

    def generate_display_name
      return unless first_name and last_name
      self.display_name = self.first_name + ' ' + self.last_name if self.display_name.blank?
    end

  # def create_profile
  #   Profile.find_or_create_by person: self
  # end

end
