class InterviewSchedulesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :chronic_time_zones, except: [:time_slots]
  before_action :set_candidate, except: [:index]

  def index
    @schedule_date = Date.parse(params[:schedule_date])
    interview_schedules = policy_scope(InterviewSchedule.where(interview_date: @schedule_date))
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
    @cloud_room = params[:cloud_room]
    @interview_schedule = InterviewSchedule.new
    get_date_and_time
    assign_schedule_attributes
    if @interview_schedule.save
      schedule_candidate
    else
      puts @interview_schedule.errors.full_messages.join(', ')
    end
  end

  def schedule
    create
  end

  def interview_now
    @interview_schedule = InterviewSchedule.new
    @interview_schedule.interview_date = Date.today.in_time_zone
    @interview_schedule.start_time = Time.zone.now
    @interview_schedule.person = @current_person
    @interview_schedule.candidate = @candidate
    if @interview_schedule.save
      @candidate.interview_scheduled!
      @current_person.log? 'interviewed_now',
                           @candidate,
                           @interview_schedule
      redirect_to new_candidate_interview_answer_path @candidate
    else
      puts @interview_schedule.errors.full_messages.join(', ')
    end
  end

  def time_slots
    @cloud_room = params[:cloud_room]
    if @cloud_room.blank?
      flash[:error] = 'Cloud room is required'
      redirect_to new_candidate_interview_schedule_path @candidate and return
    end
    get_and_handle_inputted_date
    create_taken_time_slots
    create_available_time_slots
  end

  private

  def create_taken_time_slots
    scheduled_interviews = InterviewSchedule.where(interview_date: @interview_date,
                                                   person: @current_person)
    @taken_time_slots = []
    for interview in scheduled_interviews do
      @taken_time_slots << interview.start_time.in_time_zone.strftime('%H%M')
    end
  end

  def create_available_time_slots
    time_slots_start = Time.zone.local(@interview_date.year, @interview_date.month, @interview_date.day, 9, 0, 0)
    @time_slots = []
    24.times do
      time_slot = time_slots_start.strftime('%H%M')
      unless @taken_time_slots.include? time_slot
        @time_slots << time_slots_start
      end
      time_slots_start = time_slots_start + 30.minutes
    end
  end

  def get_and_handle_inputted_date
    interview_chronic = Chronic.parse params[:interview_date]
    @interview_date = interview_chronic.to_date if interview_chronic
    if @interview_date == nil
      flash[:error] = 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
      redirect_to new_candidate_interview_schedule_path @candidate and return
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
    flash[:notice] = 'Candidate scheduled!'
    redirect_to @candidate
  end

  def get_date_and_time
    interview_date = params[:interview_date].to_date
    @interview_schedule.interview_date = interview_date
    hour = params[:interview_time].slice 0..1
    minutes = params[:interview_time].slice 2..3
    @interview_time = Time.zone.local(interview_date.year, interview_date.month, interview_date.day, hour, minutes)
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
