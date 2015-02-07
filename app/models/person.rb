require 'validators/phone_number_validator'
class Person < ActiveRecord::Base
  include ActiveModel::Validations
  extend PersonConnectFunctionality

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

    return person.team_members unless position

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
    return Person.none unless self.department
    self.department.people
  end

  def self.all_field_members
    positions = Position.where(field: true)
    Person.where(position: positions)
  end

  def self.all_hq_members
    positions = Position.where(hq: true)
    Person.where(position: positions)
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
    if Client.vonage?(self)
      ConnectOrder.sales.today.where(salesrep_id: self.connect_user_id).count
    elsif Client.sprint?(self)
      ConnectSprintSale.today.where(ad_user_id: self.connect_user_id).count
    end
  end

  def sms_messages
    to_messages = self.to_sms_messages
    from_messages = self.from_sms_messages
    to_ids = to_messages.map(&:id).join(',')
    from_ids = from_messages.map(&:id).join(',')
    ids = [to_ids, from_ids].join(',')
              .reverse.chomp(',').reverse.chomp(',')
    ids = ids.length > 0 ? ids : nil
    ids ? SMSMessage.where("id IN (#{ids})") : SMSMessage.none
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

  def clients
    self.person_areas.each.map(&:client)
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
