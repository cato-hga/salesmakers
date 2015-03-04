class InterviewSchedulesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :chronic_time_zones
  before_action :set_candidate

  def new
    @interview_schedule = InterviewSchedule.new
  end

  def create
    @interview_schedule = InterviewSchedule.new
    @interview_schedule.interview_date = params[:interview_datetime].to_date
    @interview_schedule.start_time = params[:interview_datetime].to_time
    @interview_schedule.person = @current_person
    @interview_schedule.candidate = @candidate
    if @interview_schedule.save
      redirect_to new_candidate_interview_schedule_path
    else
      puts @interview_schedule.errors.full_messages.join(', ')
    end
  end

  def schedule
    create
  end

  def time_slots
    @interview_date = Chronic.parse params[:interview_date]
    scheduled_interviews = InterviewSchedule.where interview_date: @interview_date
    start_time = @interview_date.to_time.beginning_of_day
    @time_slots = []
    taken_time_slots = []
    for interview in scheduled_interviews do
      taken_time_slots << interview.start_time
    end
    48.times do
      next if start_time == taken_time_slots.any?
      @time_slots << start_time
      start_time = start_time + 30.minutes
    end

  end

  private

  def set_candidate
    @candidate = Candidate.find_by params[:id]
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end

  def do_authorization
    authorize Candidate.new
  end
end
