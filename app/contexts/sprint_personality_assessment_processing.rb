class SprintPersonalityAssessmentProcessing

  def initialize(file)
    @file = File.new(file)
    begin_processing
    self
  end

  def begin_processing
    set_spreadsheet
    return unless @spreadsheet
    self
  end

  def set_spreadsheet
    roo_spreadsheet = Roo::Spreadsheet.open(@file.path, extension: :xls)
    @candidate_scores = []
    roo_spreadsheet.each(candidate_email: /Email/, score: /Percentile/, first_name: /First Name/, last_name: /Last Name/) do |hash|
      @candidate_scores << hash
    end
    @candidate_scores.shift
    iterate_over_scores
    create_unmatched_candidates
  end

  def self.passed_assessment(candidate, score, current_person)
    current_person.log? 'passed_assessment',
                        candidate
    candidate.update personality_assessment_completed: true,
                     personality_assessment_score: score.round(2),
                     personality_assessment_status: :qualified
    unless candidate.state
      candidate.geocode
      candidate.reverse_geocode
      candidate.save
    end
    if candidate.job_offer_details and candidate.confirmed?
      if Rails.env.staging? or Rails.env.development? or Rails.env.test?
        envelope_response = 'STAGING'
      else
        envelope_response = DocusignTemplate.send_nhp candidate, current_person
      end
      job_offer_details = JobOfferDetail.new candidate: candidate,
                                             sent: DateTime.now
      if envelope_response
        job_offer_details.envelope_guid = envelope_response
      end
      job_offer_details.save
      candidate.paperwork_sent!
    end
  end

  def self.failed_assessment(candidate, score, current_person)
    current_person.log? 'failed_assessment',
                        candidate
    current_person.log? 'dismiss',
                        candidate
    if candidate.interview_schedules.any?
      InterviewSchedule.cancel_all_interviews(candidate, current_person)
    end
    denial_reason = CandidateDenialReason.find_by name: "Personality assessment score does not qualify for employment"
    CandidatePrescreenAssessmentMailer.failed_assessment_mailer(candidate).deliver_later
    candidate.update active: false,
                     status: :rejected,
                     candidate_denial_reason: denial_reason,
                     personality_assessment_completed: true,
                     personality_assessment_score: score.round(2),
                     personality_assessment_status: :disqualified
  end

  private

  def iterate_over_scores
    person = Person.find_by email: 'retailingw@retaildoneright.com'
    @unmatched_candidates = []
    for score in @candidate_scores do
      @candidate = Candidate.find_by email: score[:candidate_email].downcase
      unless @candidate
        @unmatched_candidates << score
        next
      end
      next if @candidate.personality_assessment_score.present? or (@candidate and @candidate.active == false)
      @corrected_score = score[:score] * 100
      if @corrected_score < 31
        SprintPersonalityAssessmentProcessing.failed_assessment @candidate, @corrected_score, person
      else
        SprintPersonalityAssessmentProcessing.passed_assessment @candidate, @corrected_score, person
      end
    end
  end

  def create_unmatched_candidates
    for candidate in @unmatched_candidates
      score = candidate[:score] * 100
      UnmatchedCandidate.create last_name: candidate[:last_name],
                                first_name: candidate[:first_name],
                                email: candidate[:candidate_email].downcase,
                                score: score
    end
  end

end