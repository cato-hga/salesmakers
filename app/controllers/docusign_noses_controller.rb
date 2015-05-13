class DocusignNosesController < ApplicationController
  before_action :get_person
  before_action :do_authorization, except: [:new_third_party, :create_third_party]
  after_action :verify_authorized

  def new
    @nos = DocusignNos.new
  end

  def create
    get_params
    @nos = DocusignNos.new
    verify_data; return if performed?
    assign_params
    get_nos_response
    handle_response; return if performed?
    handle_nos_saving; return if performed?
  end

  def new_third_party
    authorize @person, :third_party_nos?
    @nos = DocusignNos.new
    postpaid = Project.find_by name: 'Sprint Postpaid'
    @managers = Person.joins(:person_areas).where('person_areas.manages = true').joins(:areas).where("areas.project_id = #{postpaid.id}")
    smiles = Person.find 3
    @managers << smiles
  end

  def create_third_party
    authorize @person, :third_party_nos?
    @nos = DocusignNos.new
    @nos.third_party = true
    if params[:docusign_nos][:manager].blank?
      flash[:error] = 'A manager must be selected'
      render :new and return
    end
    @manager = Person.find params[:docusign_nos][:manager]
    if Rails.env.test? or Rails.env.development?
      @response = 'STAGING'
    else
      @response = DocusignTemplate.send_third_party_nos(
          @person,
          @manager
      )
    end
    handle_response; return if performed?
    @nos.manager = @manager
    @nos.person = @person
    handle_nos_saving; return if performed?
  end

  private

  def get_params
    @termination_date = Chronic.parse params[:docusign_nos][:termination_date]
    @last_day_worked = Chronic.parse params[:docusign_nos][:last_day_worked]
    @separation_reason = EmploymentEndReason.find params[:docusign_nos][:employment_end_reason_id] if params[:docusign_nos][:employment_end_reason_id].present?
    @eligible = params[:docusign_nos][:eligible_to_rehire]
    @retail = @person.person_areas.first.area.project.name.include?('Event') ? 'Event' : 'Retail'
    @remarks = params[:docusign_nos][:remarks] if params[:docusign_nos][:remarks]
  end

  def assign_params
    @nos.termination_date = @termination_date
    @nos.last_day_worked = @last_day_worked
    @nos.person = @person
    @nos.employment_end_reason = @separation_reason
    @nos.eligible_to_rehire = @eligible
  end

  def handle_response
    if @response
      @nos.envelope_guid = @response
    else
      flash[:error] = 'NOS could not be sent. Please send manually'
      redirect_to @person and return
    end
  end

  def handle_nos_saving
    if @nos.save
      if @nos.third_party
        flash[:notice] = 'NOS form initiated'
      else
        flash[:notice] = 'NOS form sent. Please sign off to complete!'
      end
      @current_person.log? 'sent_nos',
                           @nos,
                           @person
      redirect_to people_path and return
    else
      puts @nos.errors.full_messages
      flash[:error] = 'NOS sent, but there was an uncaught error. Double check NOS and send again if necessary'
      redirect_to @person and return
    end
  end

  def get_nos_response
    if Rails.env.staging? or Rails.env.test? or Rails.env.development?
      @response = 'STAGING'
    else
      @response = DocusignTemplate.send_nos(
          @person,
          @current_person,
          @last_day_worked,
          @termination_date,
          @separation_reason,
          @eligible,
          @retail,
          @remarks,
      )
    end
  end

  def verify_data
    if @termination_date.blank? or @last_day_worked.blank? or @separation_reason.blank? or @eligible == ''
      check_and_handle_errors
      render :new and return
    end
  end

  def check_and_handle_errors
    if @termination_date.blank?
      @nos.errors.add :termination_date, ' entered could not be used or is blank. Please double check and try again'
    end
    if @last_day_worked.blank?
      @nos.errors.add :last_day_worked, ' entered could not be used or is blank. Please double check and try again'
    end
    if @separation_reason.blank?
      @nos.errors.add :separation_reason, ' must be selected'
    end
    if @eligible == ''
      @nos.errors.add :eligible_to_rehire, ' must be selected'
    end
  end

  def do_authorization
    authorize @person, :terminate?
  end

  def get_person
    @person = Person.find params[:person_id]
  end
end
