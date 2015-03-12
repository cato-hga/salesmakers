require 'apis/gateway'

class CandidatesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :get_candidate, except: [:index, :new, :create]
  before_action :get_suffixes_and_sources, only: [:new, :create, :edit, :update]

  def index
    @search = Candidate.search(params[:q])
    @candidates = @search.result.page(params[:page])
  end

  def show
    @candidate = Candidate.find params[:id]
    @candidate_contacts = @candidate.candidate_contacts
  end

  def new
    @candidate = Candidate.new
    @call_initiated = DateTime.now.to_i
  end

  def create
    @candidate = Candidate.new candidate_params.merge(created_by: @current_person)
    @projects = Project.all
    call_initiated = Time.at(params[:call_initiated].to_i)
    cookies[:candidate_source_selection] = candidate_params[:candidate_source_id]
    cookies[:candidate_project_select] = candidate_params[:project_id]
    if @candidate.save and params.permit(:start_prescreen)[:start_prescreen] == 'true'
      @current_person.log? 'create',
                           @candidate
      flash[:notice] = 'Candidate saved!'
      redirect_to new_candidate_prescreen_answer_path @candidate
    elsif @candidate.save and params.permit(:start_prescreen)[:start_prescreen] == 'false'
      @current_person.log? 'create',
                           @candidate
      create_voicemail_contact(call_initiated)
      flash[:notice] = 'Candidate saved!'
      redirect_to candidates_path
    else
      render :new
    end
    cookies.delete :candidate_source_selection
    cookies.delete :candidate_project_select
  end

  def edit
  end

  def update
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

  def destroy
    @candidate.update active: false
    @current_person.log? 'dismiss',
                         @candidate
    flash[:notice] = 'Candidate dismissed'
    redirect_to candidates_path
  end

  def select_location
    @candidate = Candidate.find params[:id]
    all_location_areas = get_all_location_areas
    @search = all_location_areas.search(params[:q])
    @location_areas = order_by_distance(@search.result)
    logger.debug params.inspect
    @send_nhp = params[:send_nhp] == 'true' ? true : false
  end

  def set_location_area
    @candidate = Candidate.find params[:id]
    @location_area = LocationArea.find params[:location_area_id]
    @send_nhp = params[:send_nhp] == 'true' ? true : false
    previous_location_area = @candidate.location_area
    unless @candidate.update(location_area: @location_area)
      flash[:error] = @candidate.errors.full_messages.join(', ')
      redirect_to select_location_candidate_path(@candidate, @send_nhp.to_s) and return
    end
    if previous_location_area
      previous_location_area.update potential_candidate_count: previous_location_area.potential_candidate_count - 1
    end
    @location_area.update potential_candidate_count: @location_area.potential_candidate_count + 1
    @candidate.location_selected!
    flash[:notice] = 'Location chosen successfully.'
    if @send_nhp
      redirect_to send_paperwork_candidate_path(@candidate)
    else
      redirect_to new_candidate_interview_schedule_path(@candidate)
    end
  end

  def confirm_location
    @candidate = Candidate.find params[:id]
  end

  def send_paperwork
    envelope_response = DocusignTemplate.send_nhp @candidate, @current_person
    job_offer_details = JobOfferDetail.new candidate: @candidate,
                                           sent: DateTime.now
    if envelope_response
      job_offer_details.envelope_guid = response
      flash[:notice] = 'Paperwork sent successfully.'
    else
      flash[:error] = 'Could not send paperwork automatically. Please send now manually.'
    end
    job_offer_details.save
    @candidate.paperwork_sent!
    redirect_to @candidate
  end

  def new_sms_message
    @candidate = Candidate.find params[:id]
  end

  def create_sms_message
    candidate = Candidate.find params[:id]
    message = sms_message_params[:contact_message]
    gateway = Gateway.new '+18133441170'
    gateway.send_text_to_candidate @candidate, message, @current_person
    flash[:notice] = 'Message successfully sent.'
    redirect_to candidate_path(@candidate)
  end

  private

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

  def sms_message_params
    params.permit :contact_message
  end

  def do_authorization
    authorize Candidate.new
  end

  def get_all_location_areas
    all_locations = Location.
        joins(:location_areas).
        where('location_areas.target_head_count > 0')
    return LocationArea.none if all_locations.count(:all) < 1
    all_locations = Location.where("locations.id IN (#{all_locations.map(&:id).join(',')})")
    locations = all_locations.near(@candidate, 30)
    if not locations or locations.count(:all) < 5
      locations = all_locations.near(@candidate, 500).first(5)
    end
    return LocationArea.none if locations.empty?
    location_areas = locations.map { |l| l.location_areas }.flatten
    LocationArea.where("location_areas.id IN (#{location_areas.map(&:id).join(',')})")
  end

  def get_staffable_projects
    Project.
        joins(:areas).
        joins(:location_areas).
        where('location_areas.target_head_count > 0')
  end

  def get_project_location_areas(project)
    project_locations = Project.locations(project)
    locations = project_locations.near(@candidate, 30)
    if not locations or locations.count(:all) < 5
      locations = project_locations.near(@candidate, 500).first(5)
    end
    LocationArea.
        where(location: locations).
        joins(:area).
        where("areas.project_id = ?", project.id)
  end

  def get_location_areas(location)
    location.
        location_areas.
        joins(:area).
        where('areas.project_id = ?', @candidate.project_id)
  end

  def order_by_distance(location_areas)
    return [] if location_areas.empty? or not @candidate
    location_areas.sort do |x, y|
      x.location.geographic_distance(@candidate) <=>
          y.location.geographic_distance(@candidate)
    end
  end
end
