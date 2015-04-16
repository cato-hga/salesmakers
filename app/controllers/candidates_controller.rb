require 'apis/gateway'
require 'candidates/assessments.rb'
require 'candidates/available_locations.rb'
require 'candidates/locations.rb'
require 'candidates/paperwork.rb'
require 'candidates/sms_messages.rb'
require 'candidates/status.rb'
require 'candidates/training.rb'


class CandidatesController < ApplicationController
  include CandidateDashboard
  include AvailabilityParams

  after_action :verify_authorized
  before_action :do_authorization
  before_action :search_bar, except: [:support_search]
  before_action :get_candidate, except: [:index, :support_search, :dashboard, :new, :create]
  before_action :get_suffixes_and_sources, only: [:new, :create, :edit, :update]

  layout 'candidates', except: [:support_search]
  layout 'application', only: [:support_search]

  def index
    @candidates = @search.result.page(params[:page])
  end

  def support_search
    region = AreaType.where name: 'Sprint Postpaid Region'
    @regions = Area.where area_type: region
    statuses = Candidate.statuses
    @search = Candidate.where("status >= 10").search(params[:q])
    @statuses = []
    for status in statuses do
      @statuses << status if status[1] >= 10
    end
    @candidates = @search.result.page(params[:page])
  end

  def dashboard
    set_datetime_range
    set_dashboard_variables
    set_screening_check('sex_offender_check')
    set_screening_check('public_background_check')
    set_screening_check('private_background_check')
    set_screening_check('drug_screening')
    set_screened('partially_screened')
    set_screened('fully_screened')
  end

  def show
    @candidate = Candidate.find params[:id]
    @candidate_contacts = @candidate.candidate_contacts
    @log_entries = @candidate.related_log_entries.page(params[:log_entries_page]).per(10)
    @candidate_availability = @candidate.candidate_availability if @candidate.candidate_availability
    @candidate_shifts = Shift.where(person: @candidate.person) if @candidate.person
    if @candidate.person and @candidate_shifts.present?
      @candidate_total_hours = @candidate_shifts.sum(:hours).round(2)
      @candidate_hours_last_week = @candidate_shifts.where('date > ? ', Date.today - 7.days).sum(:hours).round(2)
      @last_shift_date = @candidate_shifts.last.date.strftime('%b %e')
      @last_shift_location = @candidate_shifts.last.location.display_name
    end
    setup_sprint_params
  end

  def new
    @candidate = Candidate.new
    @candidate_source = nil
    @call_initiated = DateTime.now.to_i
  end

  def create
    @candidate = Candidate.new candidate_params.merge(created_by: @current_person)
    @projects = Project.all
    @candidate_source = CandidateSource.find_by id: candidate_params[:candidate_source_id]
    outsourced = CandidateSource.find_by name: 'Outsourced'
    @select_location = params[:select_location] == 'true' ? true : false
    check_and_handle_unmatched_candidates
    if @candidate_source == outsourced
      handle_outsourced
    elsif @candidate.save and @select_location
      create_and_select_location
    elsif @candidate.save
      create_without_selecting_location
    else
      render :new
    end
  end

  def edit
    @candidate_source = @candidate.candidate_source
  end

  def update
    @candidate_source = @candidate.candidate_source
    if @candidate.update candidate_params
      @current_person.log? 'update',
                           @candidate
      flash[:notice] = 'Candidate updated'
      redirect_to candidate_path @candidate
    else
      flash[:notice] = 'Candidate could not be saved:'
      render :edit
    end
  end

  include Candidates::Assessments
  include Candidates::AvailableLocations
  include Candidates::Locations
  include Candidates::Paperwork
  include Candidates::SMSMessages
  include Candidates::Status
  include Candidates::Training

  private

  def search_bar
    @search = Candidate.search(params[:q])
  end

  def create_and_select_location
    @current_person.log? 'create',
                         @candidate
    flash[:notice] = 'Candidate saved!'
    redirect_to select_location_candidate_path(@candidate, 'false')
  end

  def create_without_selecting_location
    call_initiated = Time.at(params[:call_initiated].to_i)
    @current_person.log? 'create',
                         @candidate
    create_voicemail_contact(call_initiated)
    flash[:notice] = 'Candidate saved!'
    redirect_to candidates_path
  end

  def get_suffixes_and_sources
    @sources = CandidateSource.where active: true
    @suffixes = ['', 'Jr.', 'Sr.', 'II', 'III', 'IV']
  end

  def create_voicemail_contact(time)
    call_initiated = time
    CandidateContact.create candidate: @candidate,
                            person: @current_person,
                            contact_method: :phone,
                            inbound: false,
                            notes: 'Left Voicemail',
                            created_at: call_initiated
  end

  def get_candidate
    @candidate = Candidate.find params[:id]
  end

  def candidate_params
    params.require(:candidate).permit(:first_name,
                                      :last_name,
                                      :suffix,
                                      :mobile_phone,
                                      :email,
                                      :zip,
                                      :project_id,
                                      :candidate_source_id,
                                      :start_prescreen
    )
  end

  def do_authorization
    authorize Candidate.new
  end
  
  def get_staffable_projects
    Project.
        joins(:areas).
        joins(:location_areas).
        where('location_areas.target_head_count > 0')
  end

  def geocode_if_necessary
    return if @candidate.state
    @candidate.geocode
    @candidate.reverse_geocode
    @candidate.save
  end
end
