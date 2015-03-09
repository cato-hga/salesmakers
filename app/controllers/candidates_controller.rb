require 'apis/gateway'

class CandidatesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization

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
    @projects = Project.all
    @suffixes = ['Jr.', 'Sr.', 'II', 'III', 'IV']
  end

  def create
    @candidate = Candidate.new candidate_params.merge(created_by: @current_person)
    @suffixes = ['Jr.', 'Sr.', 'II', 'III', 'IV']
    if @candidate.save
      @current_person.log? 'candidate_create',
                           @candidate
      flash[:notice] = 'Candidate saved!'
      redirect_to new_candidate_prescreen_answer_path @candidate
    else
      render :new
    end
  end

  def select_location
    @candidate = Candidate.find params[:id]
    @locations = get_locations(@candidate)
  end

  def set_location
    @candidate = Candidate.find params[:id]
    @location = Location.find params[:location_id]
    location_areas = get_location_areas(@location)
    previous_location_area = @candidate.location_area
    unless location_areas and @candidate.update(location_area: location_areas.first)
      flash[:error] = "Could not update the candidate's location."
      redirect_to select_location_candidate_path(@candidate) and return
    end
    if previous_location_area
      previous_location_area.update potential_candidate_count: previous_location_area.potential_candidate_count - 1
    end
    for location_area in location_areas do
      location_area.update potential_candidate_count: location_area.potential_candidate_count + 1
    end
    @candidate.location_selected!
    flash[:notice] = 'Location chosen successfully.'
    redirect_to new_candidate_interview_schedule_path(@candidate)
  end

  def send_paperwork
    candidate = Candidate.find params[:id]
    envelope_response = DocusignTemplate.send_nhp candidate, @current_person
    job_offer_details = JobOfferDetail.new candidate: candidate,
                                           sent: DateTime.now
    if envelope_response
      job_offer_details.envelope_guid = response
      flash[:notice] = 'Paperwork sent successfully.'
    else
      flash[:error] = 'Could not send paperwork automatically. Please send now manually.'
    end
    job_offer_details.save
    candidate.paperwork_sent!
    redirect_to candidate
  end

  def new_sms_message
    @candidate = Candidate.find params[:id]
  end

  def create_sms_message
    candidate = Candidate.find params[:id]
    message = sms_message_params[:contact_message]
    gateway = Gateway.new '+18133441170'
    gateway.send_text_to_candidate candidate, message, @current_person
    flash[:notice] = 'Message successfully sent.'
    redirect_to candidate_path(candidate)
  end

  def select_person
    @candidate = Candidate.find params[:id]
    @search = policy_scope(Person).search(params[:q])
    @people = @search.result.order('display_name').page(params[:page])
  end

  def link_person
    @candidate = Candidate.find params[:id]
    @person = Person.find params[:person_id]
    if @candidate.update person: @person
      flash[:notice] = 'Successfully linked candidate to person.'
      redirect_to @candidate
    else
      flash[:error] = 'Could not update candidate.'
      redirect_to @candidate
    end
  end

  private

  def candidate_params
    params.require(:candidate).permit(:first_name,
                                      :last_name,
                                      :suffix,
                                      :mobile_phone,
                                      :email,
                                      :zip,
                                      :project_id
    )
  end

  def sms_message_params
    params.permit :contact_message
  end

  def do_authorization
    authorize Candidate.new
  end

  def get_locations(candidate)
    project_locations = Project.locations(candidate.project)
    locations = project_locations.near(@candidate, 30)
    if not locations or locations.count(:all) < 5
      locations = project_locations.near(@candidate, 500).first(5)
    end
    locations
  end

  def get_location_areas(location)
    location_areas = location.
        location_areas.
        joins(:area).
        where('areas.project_id = ?', @candidate.project_id)
  end

end
