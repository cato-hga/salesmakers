class Candidate < ActiveRecord::Base
  geocoded_by :zip
  state_abbreviations = {
      "Alabama" => "AL",
      "Alaska" => "AK",
      "Arizona" => "AZ",
      "Arkansas" => "AR",
      "California" => "CA",
      "Colorado" => "CO",
      "Connecticut" => "CT",
      "Delaware" => "DE",
      "Florida" => "FL",
      "Georgia" => "GA",
      "Hawaii" => "HI",
      "Idaho" => "ID",
      "Illinois" => "IL",
      "Indiana" => "IN",
      "Iowa" => "IA",
      "Kansas" => "KS",
      "Kentucky" => "KY",
      "Louisiana" => "LA",
      "Maine" => "ME",
      "Maryland" => "MD",
      "Massachusetts" => "MA",
      "Michigan" => "MI",
      "Minnesota" => "MN",
      "Mississippi" => "MS",
      "Missouri" => "MO",
      "Montana" => "MT",
      "Nebraska" => "NE",
      "Nevada" => "NV",
      "New Hampshire" => "NH",
      "New Jersey" => "NJ",
      "New Mexico" => "NM",
      "New York" => "NY",
      "North Carolina" => "NC",
      "North Dakota" => "ND",
      "Ohio" => "OH",
      "Oklahoma" => "OK",
      "Oregon" => "OR",
      "Pennsylvania" => "PA",
      "Rhode Island" => "RI",
      "South Carolina" => "SC",
      "South Dakota" => "SD",
      "Tennessee" => "TN",
      "Texas" => "TX",
      "Utah" => "UT",
      "Vermont" => "VT",
      "Virginia" => "VA",
      "Washington" => "WA",
      "West Virginia" => "WV",
      "Wisconsin" => "WI",
      "Wyoming" => "WY"
  }
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      if geo and geo.state_code and geo.state_code.length > 2
        obj.state = state_abbreviations[geo.state_code]
      else
        obj.state = geo.state_code
      end
    end
  end

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
           :paperwork_completed_by_candidate,
           :paperwork_completed_by_advocate,
           :paperwork_completed_by_hr,
           :onboarded
       ]

  after_validation :reverse_geocode_on_production,
                   if: ->(candidate) {
                     candidate.latitude.present? and candidate.latitude_changed?
                   }
  after_validation :geocode_on_production,
                   if: ->(candidate) {
                     candidate.zip.present? and candidate.zip_changed?
                   }
  after_validation :proper_casing

  validates :first_name, presence: true, length: {minimum: 2}
  validates :last_name, presence: true, length: {minimum: 2}
  validate :strip_phone_number
  validates :mobile_phone, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }
  validates :zip, length: { is: 5 }
  validates :candidate_source_id, presence: true
  validates :created_by, presence: true

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

  def active=(is_active)
    return if self[:active] == is_active
    self[:active] = is_active
    if is_active == false
      self.status = :rejected
      return if self.location_area.nil?
      self.location_area.update potential_candidate_count: self.location_area.potential_candidate_count - 1
    else
      return if self.location_area.nil?
      self.location_area.update potential_candidate_count: self.location_area.potential_candidate_count + 1
    end
  end

  def person=(person)
    self.status = :onboarded
    self[:person_id] = person.id
    location_area = self.location_area || return
    location_area.update potential_candidate_count: location_area.potential_candidate_count - 1,
                         current_head_count: location_area.current_head_count + 1
  end

  def related_log_entries
    LogEntry.for_candidate(self)
  end

  def passed_personality_assessment?
    location_area = self.location_area || return
    return true unless location_area.area.personality_assessment_url
    self.personality_assessment_completed?
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
