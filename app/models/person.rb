require 'validators/phone_number_validator'
class Person < ActiveRecord::Base
  include ActiveModel::Validations
  extend NonAlphaNumericRansacker
  include PersonConnectFunctionality

  before_validation :generate_display_name

  nilify_blanks

  def self.setup_validations
    validates :first_name, length: { minimum: 2 }
    validates :last_name, length: { minimum: 2 }
    validates :display_name, length: { minimum: 5 }
    validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }, uniqueness: true
    validates :personal_email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }, allow_blank: true
    validates :connect_user_id, uniqueness: true, allow_nil: true
    validates_with PhoneNumberValidator
  end

  def self.setup_associations
    setup_belongs_to
    setup_has_one
    setup_has_many
    setup_has_many_through
    setup_has_and_belongs_to_many
    setup_complex_associations
  end

  def self.setup_belongs_to
    belongs_to_associations = [
        :position, :connect_user
    ]

    belongs_to :supervisor, class_name: 'Person'
    for belongs_to_association in belongs_to_associations do
      belongs_to belongs_to_association
    end
  end

  def self.setup_has_one
    has_one :profile
    has_one :wall, as: :wallable
    has_one :group_me_user
  end

  def self.setup_has_many
    has_many_associations = [
        :person_areas, :device_deployments, :devices, :uploaded_images,
        :uploaded_videos, :blog_posts, :wall_posts, :questions, :answers,
        :answer_upvotes, :communication_log_entries, :group_me_posts,
        :employments, :person_addresses, :vonage_sale_payouts, :vonage_sales,
        :vonage_refunds, :vonage_paycheck_negative_balances
    ]

    for has_many_association in has_many_associations do
      has_many has_many_association
    end
  end

  def self.setup_has_many_through
    has_many :permissions, through: :position
    has_many :areas, through: :person_areas
    has_many :group_me_likes, through: :group_me_user
  end

  def self.setup_has_and_belongs_to_many
    has_and_belongs_to_many :poll_question_choices
  end

  def self.setup_complex_associations
    has_many :day_sales_counts, as: :saleable
    has_many :sales_performance_ranks, as: :rankable
    has_many :employees, class_name: 'Person', foreign_key: 'supervisor_id'
    has_many :to_sms_messages, class_name: 'SMSMessage', foreign_key: 'to_person_id'
    has_many :from_sms_messages, class_name: 'SMSMessage', foreign_key: 'from_person_id'
  end

  setup_validations
  setup_associations

  stripping_ransacker(:mobile_phone_number, :mobile_phone)

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

  def managed_team_members
    people = Array.new
    for person_area in self.person_areas do
      next unless person_area.area
      next unless person_area.manages
      areas = person_area.area.subtree
      for area in areas do
        people = people.concat area.people.to_a
      end
    end
    people.flatten
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
      not self.employments.empty? and
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

  def separate(separated_at = Time.now)
    if self.update(active: false, updated_at: separated_at)
      if self.devices.any?
        AssetsMailer.separated_with_assets_mailer(self).deliver_later
        AssetsMailer.asset_return_mailer(self).deliver_later
      else
        AssetsMailer.separated_without_assets_mailer(self).deliver_later
      end
    end
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
    from_messages = self.from_sms_messages
    to_messages = self.to_sms_messages
    ids = get_ids_from_sms_messages(from_messages, to_messages)
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

  def get_ids_from_sms_messages(from_messages, to_messages)
    to_ids = to_messages.map(&:id).join(',')
    from_ids = from_messages.map(&:id).join(',')
    [to_ids, from_ids].join(',')
        .reverse.chomp(',').reverse.chomp(',')
  end

end
