require 'validators/phone_number_validator'
class Person < ActiveRecord::Base
  include ActiveModel::Validations
  extend NonAlphaNumericRansacker
  extend PersonAssociationsModelExtension
  include PersonConnectFunctionality
  include PersonToPersonVisibilityModelExtension

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

  setup_validations
  setup_associations

  stripping_ransacker(:mobile_phone_number, :mobile_phone)

  default_scope { order :display_name }

  def display_name
    unless self[:display_name] and self[:display_name].length > 0
      return ''
    end
    NameCase(self[:display_name])
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
      take_down_candidate_count
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

  def field?
    self.position and self.position.field?
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

  def projects
    self.person_areas.each.map(&:project)
  end

  def manager_or_hq?
    return true if self.hq?
    manager = false
    self.person_areas.each { |pa| pa.manages? ? manager = true : next }
    manager
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
    to_ids = join_sms_message_ids(to_messages)
    from_ids = join_sms_message_ids(from_messages)
    strip_trailing_comma([to_ids, from_ids].join(','))
  end

  def join_sms_message_ids(messages)
    messages.map(&:id).join(',')
  end

  def strip_trailing_comma(string)
    string.reverse.chomp(',').reverse.chomp(',')
  end

  def take_down_candidate_count
    candidate = Candidate.find_by person: self
    return unless candidate and candidate.location_area
    location_area = candidate.location_area
    new_count = location_area.current_head_count - 1
    return if new_count < 0
    location_area.update current_head_count: new_count
  end

end
