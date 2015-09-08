# == Schema Information
#
# Table name: candidates
#
#  id                                     :integer          not null, primary key
#  first_name                             :string           not null
#  last_name                              :string           not null
#  suffix                                 :string
#  mobile_phone                           :string           not null
#  email                                  :string           not null
#  zip                                    :string           not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  person_id                              :integer
#  location_area_id                       :integer
#  latitude                               :float
#  longitude                              :float
#  active                                 :boolean          default(TRUE), not null
#  status                                 :integer          default(0), not null
#  state                                  :string(2)
#  candidate_source_id                    :integer
#  created_by                             :integer          not null
#  candidate_denial_reason_id             :integer
#  personality_assessment_completed       :boolean          default(FALSE), not null
#  shirt_gender                           :string
#  shirt_size                             :string
#  personality_assessment_status          :integer          default(0), not null
#  personality_assessment_score           :float
#  sprint_radio_shack_training_session_id :integer
#  potential_area_id                      :integer
#  training_session_status                :integer          default(0), not null
#  sprint_roster_status                   :integer
#  time_zone                              :string
#  other_phone                            :string
#  mobile_phone_valid                     :boolean          default(TRUE), not null
#  other_phone_valid                      :boolean          default(TRUE), not null
#  mobile_phone_is_landline               :boolean          default(FALSE), not null
#  vip                                    :boolean          default(FALSE), not null
#

class Candidate < ActiveRecord::Base
  include CandidateGeocodingExtension
  include CandidateValidationsAndAssocationsExtension
  extend NonAlphaNumericRansacker

  has_many :log_entries, as: :trackable, dependent: :destroy
  has_many :log_entries, as: :referenceable, dependent: :destroy


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

  enum training_session_status: [
           :pending,
           :candidate_confirmed,
           :shadow_confirmed,
           :in_class,
           :completed,
           :did_not_graduate,
           :did_not_attend,
           :not_interested,
           :future_training_class,
           :nos,
           :nclb,
           :transfer,
           :transfer_reject,
           :moved_to_other_project
       ]

  enum sprint_roster_status: [
           :roster_status_pending,
           :sprint_submitted,
           :sprint_confirmed,
           :sprint_rejected,
           :sprint_preconfirmed
       ]

  has_paper_trail
  strip_attributes
  acts_as_taggable
  geocoding_validations
  attribute_validations
  setup_assocations
  stripping_ransacker(:mobile_phone_number, :mobile_phone)

  searchable do
    text :first_name, boost: 1.5
    text :last_name, boost: 2.5
    text :email, boost: 4.5
    text :mobile_phone, boost: 4.5
  end

  default_scope { order(:first_name, :last_name) }

  def self.inactive_training_session_statuses
    [
        Candidate.training_session_statuses[:transfer],
        Candidate.training_session_statuses[:transfer_reject],
        Candidate.training_session_statuses[:nos],
        Candidate.training_session_statuses[:moved_to_other_project]
    ]
  end

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
    if is_active
      self.set_active
    else
      self.set_inactive
    end
  end

  def set_inactive
    self.location_area = nil
    self.status = :rejected
  end

  def set_active
    self.candidate_denial_reason = nil
  end

  def person=(person)
    previous_status_integer = Candidate.statuses[self.status]
    return unless person
    self.status = :onboarded
    self[:person_id] = person.id
    location_area = self.location_area || return
    offer_extended_count = location_area.offer_extended_count
    offer_extended_count -= 1 if previous_status_integer >= Candidate.statuses['accepted'] and
        previous_status_integer < Candidate.statuses['onboarded']
    location_area.update potential_candidate_count: location_area.potential_candidate_count - 1,
                         current_head_count: location_area.current_head_count + 1,
                         offer_extended_count: offer_extended_count
  end

  def location_area=(location_area)
    if location_area
      self.location_area_id = location_area.id
    else
      self.location_area_id = nil
    end
  end

  def location_area_id=(location_area_id)
    previous_location_area = self.location_area
    return if previous_location_area and previous_location_area.id == location_area_id
    self[:location_area_id] = location_area_id
    status_integer = Candidate.statuses[self.status]
    previous_location_area.change_counts(status_integer, -1) if previous_location_area
    location_area = LocationArea.find location_area_id if location_area_id
    location_area.change_counts(status_integer, 1) if location_area
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
    Candidate.statuses[self.status] >= Candidate.statuses[:confirmed]
  end

  def prescreened?
    return true if self.prescreen_answers.any?
    return true if self.location_area and self.location_area.outsourced?
    Candidate.statuses[self.status] == Candidate.statuses[:prescreened]
  end

  def paperwork_already_sent?
    Candidate.statuses[self.status] >= Candidate.statuses[:paperwork_sent]
  end

  def location_selected?
    return true if self.location_area.present?
    Candidate.statuses[self.status] == Candidate.statuses[:location_selected]
  end


  def welcome_call?
    return false if self.sprint_pre_training_welcome_call and self.sprint_pre_training_welcome_call.completed?
    self.sprint_pre_training_welcome_call and (self.sprint_pre_training_welcome_call.pending? or self.sprint_pre_training_welcome_call.started?)
    Candidate.statuses[self.status] >= Candidate.statuses[:paperwork_completed_by_advocate]
  end

  def outsourced?
    outsource_source = CandidateSource.find_by name: 'Outsourced'
    return true if self.candidate_source == outsource_source
    return true if self.location_area and self.location_area.outsourced == true
    false
  end

  def assign_potential_territory(ordered_location_areas)
    return nil if ordered_location_areas == []
    if ordered_location_areas.second and (ordered_location_areas.second.location.geographic_distance(self) < ordered_location_areas.first.location.geographic_distance(self))
      raise "Dont pass this method an unordered location array!" and return
    end
    closest_location_area = ordered_location_areas.first
    closest_area = closest_location_area.area
    self.update potential_area: closest_area
  end
end
