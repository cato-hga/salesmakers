module Candidates::Status
  def dismiss
    @denial_reasons = CandidateDenialReason.where active: true
  end

  def reactivate
    if @candidate.update active: true
      reset_candidate_status
      @current_person.log? 'reactivate',
                           @candidate
      flash[:notice] = 'Candidate reactivated. Please select a location for candidate'
      redirect_to candidate_path @candidate
    else
      flash[:error] = 'Candidate could not be reactivated'
      render :show
    end
  end

  def destroy
    @selected_reason = params[:candidate][:candidate_denial_reason_id]
    @denial_reason = CandidateDenialReason.find_by id: @selected_reason
    if @selected_reason.blank?
      flash[:error] = 'Candidate denial reason can not be blank'
      render :dismiss and return
    end
    @interviews = InterviewSchedule.where(candidate_id: @candidate.id)
    if @interviews.any?
      for interview in @interviews
        interview.update active: false
      end
    end
    @candidate.update active: false, candidate_denial_reason: @denial_reason
    @current_person.log? 'dismiss',
                         @candidate,
                         @denial_reason
    flash[:notice] = 'Candidate dismissed'
    redirect_to candidates_path
  end

  private

  def reset_candidate_status
    @candidate.location_area = nil if @candidate.location_area
    @candidate.entered!
    if @candidate.job_offer_details.any?
      @candidate.paperwork_sent!
    elsif @candidate.interview_answers.any?
      @candidate.interviewed!
    elsif @candidate.interview_schedules.any?
      @candidate.interview_scheduled!
    elsif @candidate.prescreen_answers.any?
      @candidate.prescreened!
    else
      @candidate.entered!
    end
  end
end