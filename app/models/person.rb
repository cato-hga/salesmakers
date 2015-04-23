require 'validators/phone_number_validator'
class Person < ActiveRecord::Base
  include ActiveModel::Validations
  extend NonAlphaNumericRansacker
  extend PersonAssociationsModelExtension
  include PersonConnectFunctionality
  include PersonToPersonVisibilityModelExtension
  include PersonNameModelExtension
  include PersonPositionModelExtension
  include PersonEmploymentModelExtension

  before_validation :generate_display_name

  has_paper_trail
  nilify_blanks

  def self.setup_validations
    validates :first_name, length: {minimum: 2}
    validates :last_name, length: {minimum: 2}
    validates :display_name, length: {minimum: 5}
    validates :email, format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address'}, uniqueness: true
    validates :personal_email, format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address'}, allow_blank: true
    validates :connect_user_id, uniqueness: true, allow_nil: true
    validates_with PhoneNumberValidator
  end

  setup_validations
  setup_associations

  stripping_ransacker(:mobile_phone_number, :mobile_phone)

  searchable do
    text :display_name, boost: 4.0
    text :eid, boost: 4.5
    text :email, boost: 5.5
    text :home_phone, boost: 4.0
    text :mobile_phone, boost: 4.0
    text :office_phone, boost: 4.0
    text :personal_email, boost: 5.0
  end

  default_scope { order :display_name }

  enum vonage_tablet_approval_status: [
           :no_decision,
           :denied,
           :approved
       ]

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

  def physical_address
    PersonAddress.get_physical(self)
  end

  def mailing_address
    address = PersonAddress.find_by person: self, physical: false
  end

  def skip_for_assets?
    return true if self.passed_asset_hours_requirement
    return true if Person.vonage_tablet_approval_statuses[self.vonage_tablet_approval_status] > 0
    person_areas = self.person_areas
    for person_area in person_areas do
      @skip = true unless person_area.area.project.name.include? 'Vonage'
      break if @skip
    end
    return true if @skip
    false
  end

  def get_supervisors
    return [self.supervisor] if self.supervisor
    supervisors = []
    if self.person_areas
      for person_area in person_areas do
        supervisors.concat get_person_area_supervisors(person_area)
      end
    end
    supervisors
  end

  def self.no_tablets_from_collection(people_collection)
    @devices = Device.
        joins(:device_model).
        where('device_models.name ilike ? or device_models.name ilike ? or device_models.name ilike ? or device_models.name ilike ?', 'Evo View 4G', '%Tab%', '%Ellipsis%', '%Optik%')
    people_without_assets = []
    for person in people_collection do
      tablet = false
      for device in person.devices
        tablet = true if @devices.include? device
      end
      unless tablet
        people_without_assets << person
      end
    end
    people_without_assets
  end

  private

  def get_person_area_supervisors(person_area)
    area = person_area.area
    while area.present?
      manager_person_areas = area.person_areas.where(manages: true)
      unless manager_person_areas.empty?
        return manager_person_areas.map { |p| p.person }
      end
      area = area.parent
    end
    []
  end

  def generate_display_name
    return unless first_name and last_name
    self.display_name = self.first_name + ' ' + self.last_name if self.display_name.blank?
  end

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
    candidate.update active: false if candidate
  end

end
