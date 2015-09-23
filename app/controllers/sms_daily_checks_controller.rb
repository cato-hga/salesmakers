class SMSDailyChecksController < ApplicationController

  after_action :verify_authorized

  def index
    authorize SMSDailyCheck.new
    star = Project.find_by name: 'STAR'
    @available_teams = Area.where(project: star)
    time_slots_start = Time.new(Date.current.year, Date.current.month, Date.current.day, 7, 0, 0)
    @times = []
    33.times do
      time_slot = time_slots_start.beginning_of_minute
      @times << time_slot
      time_slots_start = time_slots_start + 30.minutes
    end
    if params[:select_team]
      @team = params[:select_team]
      person_areas = PersonArea.where(area: @team).joins(:person).order('people.display_name')
      @people = []
      for area in person_areas do
        @people << area.person if area.person.active
      end
      @people
    end
  end

  def update
    authorize SMSDailyCheck.new
    # @employee = Person.find sms_daily_check_params[:person_id]
    # check = SMSDailyCheck.where('person_id = ? and date = ?', @employee.id, Date.today)
    # if check.present?
    #   check.destroy_all
    # end
    # @check = SMSDailyCheck.new sms_daily_check_params
    # if params[:commit] == 'Employee Off'
    #   @check.off_day = true
    # end
    # @check.person = @employee
    # @check.sms = @current_person
    # @check.date = Date.today
    # if @check.save
    #   # respond_to do |format|
    #   #   format.js
    #   #   format.html { redirect_to devices_path }
    #   # end
    # else
    #   flash[:error] = 'Couldnt save!'
    #   redirect_to people_path
    #   puts 'HEREEEEEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    #   puts @check.errors.full_messages
    # end
  end

  private

  def sms_daily_check_params
    params.permit(
        :person_id,
        :in_time,
        :out_time,
        :check_in_on_time,
        :check_in_uniform,
        :check_in_inside_store,
        :check_out_on_time,
        :check_out_inside_store
    )
  end
end
