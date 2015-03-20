class CandidateSchedulingDismissalsController < ApplicationController
  before_action :do_authorization
  after_action :verify_authorized

  def new
    @candidate = Candidate.find params[:candidate_id]
    @schedule_dismissal = CandidateSchedulingDismissal.new
  end

  def create
    @candidate = Candidate.find params[:candidate_id]
    @schedule_dismissal = CandidateSchedulingDismissal.new dismissal_params
    @schedule_dismissal.candidate = @candidate
    if @schedule_dismissal.save
      @denial_reason = CandidateDenialReason.find_by name: 'Scheduling Conflict'
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
    else
      render :new
    end
  end

  private

  def do_authorization
    authorize Candidate.new
  end

  def dismissal_params
    params.require(:candidate_scheduling_dismissal).permit(
        :monday_am,
        :monday_pm,
        :tuesday_am,
        :tuesday_pm,
        :wednesday_am,
        :wednesday_pm,
        :thursday_am,
        :thursday_pm,
        :friday_am,
        :friday_pm,
        :saturday_am,
        :saturday_pm,
        :sunday_am,
        :sunday_pm,
        :comment
    )
  end
end
