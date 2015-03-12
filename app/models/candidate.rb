class Candidate < ActiveRecord::Base
  geocoded_by :zip
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.state = geo.state_code
    end
  end
  after_validation :reverse_geocode_on_production

  nilify_blanks
  extend NonAlphaNumericRansacker

  enum status: [
           :entered,
           :prescreened,
           :location_selected,
           :interview_scheduled,
           :interviewed,
           :rejected,
           :accepted,
           :paperwork_sent,
           :paperwork_completed,
           :onboarded
       ]

  after_validation :geocode_on_production,
                   if: ->(candidate) {
                     candidate.zip.present? and candidate.zip_changed?
                   }
  after_validation :proper_casing

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile_phone, presence: true, uniqueness: true
  validates :email, presence: true
  validates :zip, length: { is: 5 }
  validates :candidate_source_id, presence: true
  validates :created_by, presence: true
  validate :strip_phone_number

  belongs_to :location_area
  belongs_to :person
  belongs_to :candidate_source
  belongs_to :candidate_denial_reason
  belongs_to :created_by, class_name: 'Person', foreign_key: 'created_by'

  has_many :prescreen_answers
  has_many :interview_schedules
  has_many :interview_answers
  has_many :job_offer_details
  has_many :candidate_contacts

  default_scope { order(:first_name, :last_name) }

  stripping_ransacker(:mobile_phone_number, :mobile_phone)

  def strip_phone_number
    self.mobile_phone = mobile_phone.strip.gsub /[^0-9]/, '' if mobile_phone.present?
  end

  def display_name
    "#{self.first_name} #{self.last_name}" +
        (self.suffix.blank? ? '' : ", #{self.suffix}")
  end

  def name
    display_name
  end

  def person=(person)
    self.status = :onboarded
    self[:person_id] = person.id
    location_area = self.location_area || return
    location_area.update potential_candidate_count: location_area.potential_candidate_count - 1,
                         current_head_count: location_area.current_head_count + 1
  end

  private

  def geocode_on_production
    return unless Rails.env.production? or Rails.env.staging?
    self.geocode
  end

  def reverse_geocode_on_production
    return unless Rails.env.production?
    self.reverse_geocode
  end

  def proper_casing
    self.first_name = NameCase(self.first_name) if self.first_name
    self.last_name = NameCase(self.last_name) if self.last_name
    self.email = self.email.downcase if self.email
  end
end
