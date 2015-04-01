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
      "Puerto Rico" => "PR",
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
        obj.state = geo.country == 'Puerto Rico' ? 'PR' : state_abbreviations[geo.state_code]
      else
        obj.state = geo.state_code
      end
    end
  end

  nilify_blanks
  extend NonAlphaNumericRansacker

  # NOTE: YOU CANNOT ADD A STATUS IN THE MIDDLE WITHOUT CORRECTING THE STATUSES AFTER IT. ENUM IS NOTHING
  # MORE THAN AN INTEGER, SO THE STATES AFTER THE ONE INSERTED WILL ALL SHIFT BECAUSE THEIR INTEGER VALUE
  # STAYS THE SAME. YOU MUST RUN A MIGRATION TO ADD 1 TO THE VALUE OF ALL RECORDS WITH A STATE THAT'S AFTER
  # THE NEW ONE.
  enum status: [
           :entered,
           :prescreened,
           :location_selected,
           :interview_scheduled,
           :interviewed,
           :rejected,
           :accepted,
           :confirmed,
           :paperwork_sent,
           :paperwork_completed_by_candidate,
           :paperwork_completed_by_advocate,
           :paperwork_completed_by_hr,
           :onboarded,
           :partially_screened,
           :fully_screened
       ]
  enum personality_assessment_status: [
           :incomplete,
           :disqualified,
           :qualified
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
  validates :email,
            presence: true,
            format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' },
            uniqueness: { case_sensitive: false }
  validates :zip, length: { is: 5 }
  validates :candidate_source_id, presence: true
  validates :created_by, presence: true

  belongs_to :location_area
  belongs_to :person
  belongs_to :candidate_source
  belongs_to :candidate_denial_reason
  belongs_to :created_by, class_name: 'Person', foreign_key: 'created_by'
  belongs_to :sprint_radio_shack_training_session

  has_many :prescreen_answers
  has_many :interview_schedules
  has_many :interview_answers
  has_many :job_offer_details
  has_many :candidate_contacts
  has_one :candidate_availability
  has_one :training_availability
  has_one :sprint_pre_training_welcome_call

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
    previous_status = self.status
    if is_active == false
      self.status = :rejected
      return if self.location_area.nil?
      self.location_area.update potential_candidate_count: self.location_area.potential_candidate_count - 1
      return unless Candidate.statuses[previous_status] >= Candidate.statuses['accepted']
      self.location_area.update offer_extended_count: self.location_area.offer_extended_count - 1
    else
      return if self.location_area.nil?
      self.location_area.update potential_candidate_count: self.location_area.potential_candidate_count + 1
      return unless Candidate.statuses[previous_status] >= Candidate.statuses['accepted']
      self.location_area.update offer_extended_count: self.location_area.offer_extended_count + 1
    end
  end

  def person=(person)
    return unless person
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
    return false if self.personality_assessment_status == 'disqualified'
    return true if self.personality_assessment_status == 'qualified'
    location_area = self.location_area || return
    return true if not location_area.area.personality_assessment_url and
        not location_area.outsourced?
    self.personality_assessment_completed?
  end

  def confirmed?
    Candidate.statuses[self.status] > Candidate.statuses[:confirmed]
  end

  def welcome_call?
    return false if self.sprint_pre_training_welcome_call and self.sprint_pre_training_welcome_call.completed?
    self.sprint_pre_training_welcome_call and (self.sprint_pre_training_welcome_call.pending? or self.sprint_pre_training_welcome_call.started?)
    Candidate.statuses[self.status] >= Candidate.statuses[:paperwork_completed_by_advocate]
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
