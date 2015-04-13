class Candidate < ActiveRecord::Base
  include CandidateGeocodingExtension
  include CandidateValidationsAndAssocationsExtension
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

  has_paper_trail
  nilify_blanks
  setup_geocoding
  geocoding_validations
  attribute_validations
  setup_assocations
  stripping_ransacker(:mobile_phone_number, :mobile_phone)

  default_scope { order(:first_name, :last_name) }

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
      self.set_inactive
    else
      self.set_active
    end
  end

  def set_inactive
    previous_status = self.status
    self.status = :rejected
    return if self.location_area.nil?
    self.location_area.update potential_candidate_count: self.location_area.potential_candidate_count - 1
    return unless Candidate.statuses[previous_status] >= Candidate.statuses['accepted']
    self.location_area.update offer_extended_count: self.location_area.offer_extended_count - 1
  end

  def set_active
    previous_status = self.status
    return if self.location_area.nil?
    self.location_area.update potential_candidate_count: self.location_area.potential_candidate_count + 1
    return unless Candidate.statuses[previous_status] >= Candidate.statuses['accepted']
    self.location_area.update offer_extended_count: self.location_area.offer_extended_count + 1
    self.candidate_denial_reason = nil
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
    Candidate.statuses[self.status] >= Candidate.statuses[:confirmed]
  end

  def prescreened?
    return true if self.prescreen_answers.any?
    return true if self.location_area and self.location_area.outsourced?
    Candidate.statuses[self.status] == Candidate.statuses[:prescreened]
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
