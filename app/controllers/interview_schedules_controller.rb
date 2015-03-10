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
    interview_date = params[:interview_date].to_date
    @interview_schedule.interview_date = interview_date
    hour = params[:interview_time].slice 0..1
    minutes = params[:interview_time].slice 2..3
    interview_time = Time.new(interview_date.year, interview_date.month, interview_date.day, hour, minutes).in_time_zone
    @interview_schedule.start_time = interview_time
    @interview_schedule.person = @current_person
    @interview_schedule.candidate = @candidate
    if @interview_schedule.save
      @candidate.interview_scheduled!
      InterviewScheduleMailer.interview_mailer(@candidate, @current_person, @interview_schedule, params[:cloud_room]).deliver_later
      @current_person.log? 'scheduled_for_interview',
                           @candidate,
                           @interview_schedule
      flash[:notice] = 'Candidate scheduled!'
      redirect_to @candidate
    else
      #TODO: HELP
      puts @interview_schedule.errors.full_messages.join(', ')
    end

  end

  def schedule
    create
  end

  def interview_now
    @interview_schedule = InterviewSchedule.new
    @interview_schedule.interview_date = Date.today.in_time_zone
    @interview_schedule.start_time = Time.now.in_time_zone
    @interview_schedule.person = @current_person
    @interview_schedule.candidate = @candidate
    if @interview_schedule.save
      @candidate.interview_scheduled!
      @current_person.log? 'interviewed_now',
                           @candidate,
                           @interview_schedule
      redirect_to new_candidate_interview_answer_path @candidate
    else
      #TODO: HELP
      puts @interview_schedule.errors.full_messages.join(', ')
    end
  end

  def time_slots
    @interview_date = Chronic.parse params[:interview_date]
    if @interview_date == nil
      flash[:error] = 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
      redirect_to new_candidate_interview_schedule_path @candidate and return
    end
    scheduled_interviews = InterviewSchedule.where interview_date: @interview_date
    taken_time_slots = []
    for interview in scheduled_interviews do
      taken_time_slots << interview.start_time.in_time_zone.strftime('%H%M')
    end
    time_slots_start = Time.new(@interview_date.year, @interview_date.month, @interview_date.day, 9, 0, 0).in_time_zone
    @time_slots = []
    24.times do
      time_slot = time_slots_start.strftime('%H%M')
      unless taken_time_slots.include? time_slot
        @time_slots << time_slots_start
      end
      time_slots_start = time_slots_start + 30.minutes
    end
  end

  private

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
