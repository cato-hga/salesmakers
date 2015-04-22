class DocusignNosesController < ApplicationController
  before_action :get_person
  before_action :do_authorization
  after_action :verify_authorized

  def new
    @nos = DocusignNos.new
  end

  def create
    @termination_date = Chronic.parse docusign_nos_params[:termination_date]
    @last_day_worked = Chronic.parse docusign_nos_params[:last_day_worked]
    @separation_reason = EmploymentEndReason.find docusign_nos_params[:employment_end_reason_id] if docusign_nos_params[:employment_end_reason_id].present?
    @eligible = docusign_nos_params[:eligible_to_rehire]
    @nos = DocusignNos.new docusign_nos_params
    if @termination_date.blank? or @last_day_worked.blank? or @separation_reason.blank? or @eligible.nil?
      check_and_handle_errors
      puts @nos.errors.full_messages
      render :new and return
    end
    @nos.person = @person
    retail = @person.person_areas.first.area.project.name.include?('Retail') ? true : false
    response = DocusignTemplate.send_nos(
        @person,
        @current_person,
        @last_day_worked,
        @termination_date,
        @separation_reason,
        @eligible,
        retail,
        docusign_nos_params[:remarks],
    )
    if response
      @nos.envelope_guid = response
    else
      flash[:error] = 'NOS could not be sent. Please send manually'
      redirect_to @person and return
    end
    if @nos.save
      flash[:notice] = 'NOS form sent. Please sign off to complete!'
      @current_person.log? 'sent_nos',
                           @nos,
                           @person
      redirect_to people_path
    else
      flash[:error] = 'NOS could not be sent. Please send manually'
      redirect_to @person
    end
  end

  private

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
    if @eligible.nil?
      @nos.errors.add :eligible_to_rehire, ' must be selected'
    end
  end

  def do_authorization
    authorize @person, :terminate?
  end

  def get_person
    @person = Person.find params[:person_id]
  end

  def docusign_nos_params
    params.require(:docusign_nos).permit(
        :eligible_to_rehire,
        :termination_date,
        :last_day_worked,
        :remarks,
        :envelope_guid,
        :employment_end_reason_id,
        :person_id
    )
  end
end
