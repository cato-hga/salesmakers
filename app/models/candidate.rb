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

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile_phone, presence: true, uniqueness: true
  validates :email, presence: true
  validates :zip, length: { is: 5 }
  validates :project_id, presence: true
  validate :strip_phone_number

  belongs_to :project
  belongs_to :location_area
  belongs_to :person

  has_many :prescreen_answers
  has_many :interview_schedules
  has_many :interview_answers
  has_many :job_offer_details

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

  private

  def geocode_on_production
    return unless Rails.env.production?
    self.geocode
  end

  def reverse_geocode_on_production
    return unless Rails.env.production?
    self.reverse_geocode
  end
end
