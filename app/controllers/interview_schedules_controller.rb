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
      @current_person.log? 'scheduled_for_interview',
                           @candidate,
                           @interview_schedule
      redirect_to new_candidate_path
    else
      puts @interview_schedule.errors.full_messages.join(', ')
    end
  end

  def schedule
    create
  end

  def time_slots
    @interview_date = Chronic.parse params[:interview_date]
    if @interview_date == nil
      flash[:error] = 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
      redirect_to new_candidate_interview_schedule_path @candidate and return
    end

    #Creating the time slots
    scheduled_interviews = InterviewSchedule.where interview_date: @interview_date
    time_slots_start = @interview_date.to_time.beginning_of_day
    @time_slots = []
    48.times do
      @time_slots << time_slots_start
      time_slots_start = time_slots_start + 30.minutes
    end

    #Finding taken time slots
    taken_time_slots = []
    for interview in scheduled_interviews do
      taken_time_slots << interview.start_time
    end
    puts taken_time_slots.inspect

    for slot in @time_slots do
      puts slot.inspect
      if taken_time_slots.include? slot
        slot.delete
      end
    end
    @time_slots
    puts @time_slots.first
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
