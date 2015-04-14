module Candidates::Assessments
  def record_assessment_score
    begin
      @score = Float params[:assessment_score]
    rescue
      flash[:error] = 'Score must be a number'
      redirect_to candidate_path(@candidate) and return
    end
    if @score > 100
      flash[:error] = 'Score cannot be greater than 100. Please try again.'
      redirect_to candidate_path(@candidate) and return
    end
    if @score < 31
      failed_assessment
    else
      passed_assessment
    end
  end

  def resend_assessment
    unless @candidate.location_area
      flash[:error] = 'You cannot resend the assessment because there is no location selected for the candidate.'
      redirect_to @candidate and return
    end
    CandidatePrescreenAssessmentMailer.assessment_mailer(@candidate, @candidate.location_area.area).deliver_later
    @current_person.log? 'sent_assessment',
                         @candidate
    flash[:notice] = 'Personality assessment email resent.'
    redirect_to @candidate
  end

  private

  def check_and_handle_unmatched_candidates
    return unless @candidate.save
    unmatched_candidate = UnmatchedCandidate.find_by email: @candidate.email
    return unless unmatched_candidate
    person = Person.find_by email: 'retailingw@retaildoneright.com'
    if unmatched_candidate.score < 31
      SprintPersonalityAssessmentProcessing.failed_assessment @candidate, unmatched_candidate.score, person
    else
      SprintPersonalityAssessmentProcessing.passed_assessment @candidate, unmatched_candidate.score, person
    end
  end

  def passed_assessment
    SprintPersonalityAssessmentProcessing.passed_assessment(@candidate, @score, @current_person)
    if @candidate.confirmed?
      redirect_to send_paperwork_candidate_path(@candidate)
    else
      flash[:notice] = 'Marked candidate as having qualified for employment per the personality assessment score. ' +
          'Paperwork will be sent after details are confirmed.'
      redirect_to candidate_path(@candidate)
    end
  end

  def failed_assessment
    SprintPersonalityAssessmentProcessing.failed_assessment(@candidate, @score, @current_person)
    flash[:notice] = 'Marked candidate as having been disqualified for employment per the personality assessment score.'
    redirect_to candidate_path(@candidate)
  end
end