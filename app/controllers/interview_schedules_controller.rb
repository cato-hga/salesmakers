class InterviewSchedulesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization

  def new
    @interview_schedule = InterviewSchedule.new
    @candidate = Candidate.find_by params[:id]
  end

  def create

  end

  private

  def do_authorization
    authorize Candidate.new
  end
end
