require 'apis/gateway'
require 'candidates/assessments.rb'
require 'candidates/available_locations.rb'
require 'candidates/locations.rb'
require 'candidates/paperwork.rb'
require 'candidates/communications.rb'
require 'candidates/status.rb'
require 'candidates/training.rb'
require 'candidates/variables.rb'

class CandidatesController < ApplicationController
  include CandidateDashboard
  include AvailabilityParams
  include Candidates::Assessments
  include Candidates::AvailableLocations
  include Candidates::Locations
  include Candidates::Paperwork
  include Candidates::Communications
  include Candidates::Status
  include Candidates::Training
  include Candidates::Variables #Any methods that are 'get_{something}' go here.


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

  def show
    @candidate = Candidate.find params[:id]
    get_show_variables
    get_hours_information
    setup_sprint_params
  end

  def new
    @candidate = Candidate.new
    @candidate_source = nil
    @call_initiated = DateTime.now.to_i
  end

  def create
    @candidate = Candidate.new candidate_params.merge(created_by: @current_person)
    get_create_variables
    check_and_handle_unmatched_candidates
    if @select_location or @candidate.candidate_source == @outsourced
      create_and_select_location; return if performed?
    end
    if @candidate.save
      create_without_selecting_location; return if performed?
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

  def set_reconciliation_status
    status = params[:candidate_reconciliation][:status]
    @candidate_reconciliation = CandidateReconciliation.new
    @candidate_reconciliation.status = status
    @candidate_reconciliation.candidate = @candidate
    if @candidate_reconciliation.save
      @current_person.log? 'set_reconciliation_status',
                           @candidate,
                           nil,
                           nil,
                           nil,
                           NameCase(status.humanize)
      flash[:notice] = 'Candidate Reconciliation Status saved'
      redirect_to candidate_path(@candidate)
    end
  end

  private

  def search_bar
    @search = Candidate.search(params[:q])
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

  def geocode_if_necessary
    return if @candidate.state
    @candidate.geocode
    @candidate.reverse_geocode
    @candidate.save
  end
end
