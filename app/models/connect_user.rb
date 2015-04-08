require 'apis/gateway'

class ConnectUser < ConnectModel
  self.table_name = :ad_user
  self.primary_key = :ad_user_id

  has_many :connect_regions,
           foreign_key: 'salesrep_id'
  has_one :person
  belongs_to :supervisor,
             class_name: 'ConnectUser'
  has_many :employees,
           class_name: 'ConnectUser',
           foreign_key: 'supervisor_id'
  belongs_to :creator,
             class_name: 'ConnectUser',
             foreign_key: 'createdby'
  belongs_to :updater,
             class_name: 'ConnectUser',
             foreign_key: 'updatedby'
  has_one :connect_business_partner,
          foreign_key: 'c_bpartner_id',
          primary_key: 'c_bpartner_id'
  has_many :connect_terminations,
           foreign_key: 'ad_user_id',
           primary_key: 'ad_user_id'
  has_many :connect_user_mappings,
           foreign_key: 'ad_user_id',
           primary_key: 'ad_user_id'

  #:nocov:
  def self.not_main_administrators
    self.where("username != 'retailingw@retaildoneright.com' AND username != 'aatkinson@retaildoneright.com' AND username != 'smiles@retaildoneright.com' AND (username LIKE '%@retaildoneright.com' OR username LIKE '%@rbd%.com') AND lower(firstname) != 'x' AND ad_org_id = '6B3C6669E32B43E1A1B14788C0CD0146' AND username NOT LIKE '%@%clear%.com'")
  end

  def self.creation_order
    self.order :created
  end

  def log?(action, trackable, referenceable = nil, created_at = nil, updated_at = nil)
    person = Person.return_from_connect_user self
    return false unless person
    person.log?(action, trackable, referenceable, created_at, updated_at)
  end

  def active?
    if isactive == 'Y'
      true
    else
      false
    end
  end

  def leader?
    if connect_regions.count > 0
      true
    else
      false
    end
  end

  def region
    if connect_regions.count < 1
      return nil unless supervisor.present? and supervisor.connect_regions.count > 0
      return supervisor.connect_regions.first
    else
      return connect_regions.first
    end
  end

  def fast_type
    connect_user_region = region || return
    region.fast_type
  end

  def project
    user_region = region
    return nil if user_region == nil
    region.project
  end

  def display_name
    return name if name
    [firstname, lastname].join(' ')
  end

  def personal_email
    return nil unless description and description.match /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/
    description
  end

  def email
    return username if username.match /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/
    cleaned_email = username.gsub /[^0-9A-Za-z]/, ''
    cleaned_email = cleaned_email.strip
    return cleaned_email if cleaned_email.match /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/
    cleaned_email + '@retailingwireless.com'
  end

  def phone
    phone_attribute = read_attribute :phone
    phone2_attribute = phone2

    phone_number = '8005551212'
    if phone_attribute
      phone_attribute = phone_attribute.strip.gsub(/[^0-9]/, '')
      phone_number = phone_attribute if /\A[2-9][0-9]{2}[1-9][0-9]{6}\z/.match(phone_attribute)
    end
    if phone2_attribute
      phone2_attribute = phone2_attribute.strip.gsub(/[^0-9]/, '')
      phone_number = phone2_attribute if /\A[2-9][0-9]{2}[1-9][0-9]{6}\z/.match(phone2_attribute)
    end
    phone_number
  end

  def text_blueforce_credentials
    return unless self.connect_user_mappings and self.connect_user_mappings.blueforce_usernames.first.mapping.present?
    username = self.connect_user_mappings.blueforce_usernames.first unless self.connect_user_mappings.blueforce_usernames.empty?
    password = self.connect_user_mappings.blueforce_passwords.first unless self.connect_user_mappings.blueforce_passwords.empty?
    return unless username and password
    message_one = "Welcome to SalesMakers! Here is your username and password for EPAY Blueforce. Use this to clock in and record your hours."
    message_two = "Username: #{username.mapping}, Password: #{password.mapping}"
    message_three = "Click here for the EPAY Android app: http://bit.ly/1GEpt7E"
    message_four = "Click here for the EPAY IOS app: http://apple.co/1acglus"
    gateway = Gateway.new
    gateway.send_text self.person.mobile_phone, message_one
    sleep 0.1
    gateway.send_text self.person.mobile_phone, message_two
    sleep 0.1
    gateway.send_text self.person.mobile_phone, message_three
    sleep 0.1
    gateway.send_text self.person.mobile_phone, message_four
  end

  #:nocov:
end