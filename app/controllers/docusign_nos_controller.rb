class DocusignNosController < ApplicationController
  before_action :do_authorization
  before_action :get_person
  after_action :verify_authorized

  def new
    @nos = DocusignNos.new
  end

  def create
    @termination_date = Chronic.parse docusign_nos_params[:termination_date]
    @last_day_worked = Chronic.parse docusign_nos_params[:last_day_worked]
    if @termination_date.blank? or @last_day_worked.blank?
      flash[:notice] = 'The dates entered could not be used or are blank. Please double check and try again'
      render :new and return
    end
    @nos = DocusignNos.new docusign_nos_params
    @nos.person = @person
    retail = @person.person_areas.first.area.project.name.include?('Retail') ? true : false
    separation_reason = EmploymentEndReason.find docusign_nos_params[:employment_end_reason_id]
    response = DocusignTemplate.send_nos(
        @person,
        @current_person,
        @last_day_worked,
        @termination_date,
        separation_reason,
        docusign_nos_params[:eligible_to_rehire],
        retail,
        docusign_nos_params[:remarks],
    )
    if response
      @nos.envelope_guid = response
    else
      flash[:notice] = 'NOS could not be sent. Please send manually'
      redirect_to @person and return
    end
    if @nos.save
      flash[:notice] = 'NOS form sent. Please sign off to complete!'
      @current_person.log? 'sent_nos',
                           @nos,
                           @person
      redirect_to people_path
    else
      flash[:notice] = 'NOS could not be sent. Please send manually'
      redirect_to @person
    end
  end

  private

  def do_authorization
    authorize DocusignNos.new
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
