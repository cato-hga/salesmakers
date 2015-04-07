class SprintPersonalityAssessmentProcessing

  def initialize(file)
    @file = File.new(file)
    begin_processing
    self
  end

  def begin_processing
    set_spreadsheet
    return unless @spreadsheet
    #process_row_hashes
    self
  end

  # def process_row_hashes
  #   for row_hash in @spreadsheet.hashes do
  #     puts row_hash.inspect
  #   end
  # end

  def set_spreadsheet
    roo_spreadsheet = Roo::Spreadsheet.open(@file.path, extension: :xlsx)
    candidate_scores = []
    roo_spreadsheet.each(candidate_email: /Email/, score: /Percentile/) do |hash|
      candidate_scores << hash
    end
    candidate_scores.shift
    for score in candidate_scores do
      candidate = Candidate.find_by email: score[:candidate_email]
      next unless candidate
      corrected_score = score[:score] * 100
      if corrected_score < 31
        denial_reason = CandidateDenialReason.find_by name: "Personality assessment score does not qualify for employment"
        CandidatePrescreenAssessmentMailer.failed_assessment_mailer(candidate).deliver_later
        candidate.update active: false,
                         status: :rejected,
                         candidate_denial_reason: denial_reason,
                         personality_assessment_completed: true,
                         personality_assessment_score: corrected_score,
                         personality_assessment_status: :disqualified
      else
        candidate.update personality_assessment_completed: true,
                         personality_assessment_score: corrected_score,
                         personality_assessment_status: :qualified
      end
    end
  end
end