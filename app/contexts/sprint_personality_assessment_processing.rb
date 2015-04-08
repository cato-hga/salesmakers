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
    roo_spreadsheet = Roo::Spreadsheet.open(@file.path, extension: :xlsx)
    candidate_scores = []
    roo_spreadsheet.each(candidate_email: /Email/, score: /Percentile/) do |hash|
      candidate_scores << hash
    end
    candidate_scores.shift
    person = Person.find_by email: 'retailingw@retaildoneright.com'
    for score in candidate_scores do
      @candidate = Candidate.find_by email: score[:candidate_email]
      next unless @candidate
      @corrected_score = score[:score] * 100
      if @corrected_score < 31
        SprintPersonalityAssessmentProcessing.failed_assessment @candidate, @corrected_score, person
      else
        SprintPersonalityAssessmentProcessing.passed_assessment @candidate, @corrected_score, person
      end
    end
  end

  def self.passed_assessment(candidate, score, current_person)
    current_person.log? 'passed_assessment',
                        candidate
    candidate.update personality_assessment_completed: true,
                     personality_assessment_score: score,
                     personality_assessment_status: :qualified
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
                     personality_assessment_score: score,
                     personality_assessment_status: :disqualified
  end
end