class InterviewSchedulesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :chronic_time_zones, except: [:time_slots]
  before_action :set_candidate, except: [:index, :destroy]
  before_action :get_and_handle_inputted_date, only: [:time_slots]

  def index
    @schedule_date = Date.parse(params[:schedule_date])
    interview_schedules = policy_scope(InterviewSchedule.where(interview_date: @schedule_date, active: true))
    @interview_schedules = {}
    cookies[:show_open_time_slots] ? nil : cookies[:show_open_time_slots] = true
    for schedule in interview_schedules do
      recruiter = schedule.person
      recruiter_schedules = @interview_schedules[recruiter] || []
      recruiter_schedules << schedule
      @interview_schedules[recruiter] = recruiter_schedules
    end
  end

  def new
    @interview_schedule = InterviewSchedule.new
  end

  def create
    handle_previous_interviews
    @cloud_room = params[:cloud_room]
    @interview_schedule = InterviewSchedule.new
    get_date_and_time
    assign_schedule_attributes
    if @interview_schedule.save
      @interview_schedule.update active: true
      schedule_candidate
      cookies.delete :cloud_room
    else
      render :new
    end
  end

  def schedule
    create
  end

  def interview_now
    handle_previous_interviews
    @interview_schedule = InterviewSchedule.new
    @interview_schedule.interview_date = Date.today.in_time_zone
    @interview_schedule.start_time = Time.zone.now
    @interview_schedule.person = @current_person
    @interview_schedule.candidate = @candidate
    @cloud_room = cookies[:cloud_room]
    if @interview_schedule.save
      @candidate.interview_scheduled!
      @interview_schedule.update active: true
      @current_person.log? 'interviewed_now',
                           @candidate,
                           @interview_schedule
      InterviewScheduleMailer.interview_now_mailer(@candidate, @current_person, @interview_schedule, @cloud_room).deliver_later
      redirect_to new_candidate_interview_answer_path @candidate
      cookies.delete :cloud_room
    else
      render :new
    end
  end

  def time_slots
    @cloud_room = params[:cloud_room]
    cookies[:cloud_room] = params[:cloud_room]
    if @cloud_room.blank?
      flash[:error] = 'Cloud room is required'
      redirect_to new_candidate_interview_schedule_path @candidate and return
    end
    #get_and_handle_inputted_date is in a before filter, because it wasn't return correct, being in a private method
    create_taken_time_slots
    create_available_time_slots
  end

  def destroy
    @interview_schedule = InterviewSchedule.find params[:id]
    candidate = @interview_schedule.candidate
    @interview_schedule.update active: false
    @current_person.log? 'cancel',
                         @interview_schedule,
                         candidate
    redirect_to interview_schedules_path @interview_schedule.interview_date
  end

  private

  def handle_previous_interviews
    if @candidate.interview_schedules.any?
      InterviewSchedule.cancel_all_interviews(@candidate, @current_person)
    end
  end

  def create_taken_time_slots
    adjusted_date = @interview_date.to_time.in_time_zone +
        Time.zone.utc_offset +
        (@interview_date.to_time.in_time_zone.dst? ? 3600 : 0)
    scheduled_interviews = InterviewSchedule.where(interview_date: adjusted_date.to_date,
                                                   person: @current_person)
    @taken_time_slots = []
    for interview in scheduled_interviews do
      @taken_time_slots << interview.start_time.in_time_zone.beginning_of_minute
    end
  end

  def create_available_time_slots
    adjusted_date = @interview_date.to_time.in_time_zone +
        Time.zone.utc_offset +
        (@interview_date.to_time.in_time_zone.dst? ? 3600 : 0)
    time_slots_start = Time.zone.local(adjusted_date.year, adjusted_date.month, adjusted_date.day, 9, 0, 0)
    @time_slots = []
    24.times do
      time_slot = time_slots_start.beginning_of_minute
      unless @taken_time_slots.include? time_slot
        @time_slots << time_slots_start
      end
      time_slots_start = time_slots_start + 30.minutes
    end
  end

  def get_and_handle_inputted_date
    @interview_date = Chronic.parse params[:interview_date]
    if @interview_date == nil or @interview_date < Date.current
      flash[:error] = 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
      redirect_to new_candidate_interview_schedule_path @candidate
    end
  end

  def assign_schedule_attributes
    @interview_schedule.start_time = @interview_time
    @interview_schedule.person = @current_person
    @interview_schedule.candidate = @candidate
  end

  def schedule_candidate
    @candidate.interview_scheduled!
    InterviewScheduleMailer.interview_mailer(@candidate, @current_person, @interview_schedule, @cloud_room).deliver_later
    @current_person.log? 'scheduled_for_interview',
                         @candidate,
                         @interview_schedule
    if @candidate.location_area and !@candidate.location_area.recruitable?
      @candidate.update location_area: nil
      flash[:error] = 'The location selected for the candidate was recently filled or is not recruitable. Please select a new, recruitable, location'
    end
    flash[:notice] = 'Candidate scheduled!'
    redirect_to @candidate
  end

  def get_date_and_time
    interview_date = params[:interview_date].to_date
    @interview_schedule.interview_date = interview_date
    hour = params[:interview_time].slice 0..1
    minutes = params[:interview_time].slice 2..3
    @interview_time = Time.zone.local(interview_date.year, interview_date.month, interview_date.day, hour, minutes, 0)
  end

  def set_candidate
    @candidate = Candidate.find params[:candidate_id]
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end

  def do_authorization
    authorize Candidate.new
  end
end
