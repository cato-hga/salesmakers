class RosterVerificationSessionsController < ApplicationController

  def new
    @verifying_for = params[:manager_id] ? Person.find(params[:manager_id]) : @current_person
    @managed_managers = @verifying_for.managed_managers.to_a.unshift(@verifying_for).unshift(@current_person).uniq
    @areas = Area.get_direct_management_areas @verifying_for
    @roster_verification_session = RosterVerificationSession.new creator: @verifying_for
    @issues = [
        [
            "I don't know who this person is",
            "I don't know who this person is"
        ],
        [
            "This person was transferred to another project",
            "This person was transferred to another project"
        ],
        [
            "This person has the wrong job title",
            "This person has the wrong job title"
        ],
        [
            "This person is a duplicate",
            "This person is a duplicate"
        ],
        [
            "This person is in the wrong territory",
            "This person is in the wrong territory"
        ]
    ]
  end

  def create
    @roster_verification_session = RosterVerificationSession.new roster_verification_session_params
    @roster_verification_session.roster_verifications.each {|v| v.roster_verification_session = @roster_verification_session}
    if @roster_verification_session.save
      RosterVerificationDocusignJob.perform_later @roster_verification_session
      RosterVerificationMailer.send_employee_exceptions(@roster_verification_session).deliver_later
      @current_person.log? 'verify_roster',
                           @current_person,
                           @roster_verification_session
      flash[:notice] = 'Roster verification records saved successfully.'
      redirect_to root_path
    else
      flash[:error] = 'The roster verification records could not be saved. This should not happen. Please contact support.'
      redirect_to new_roster_verification_session_path
    end
  end

  private

  def roster_verification_session_params
    params.require(:roster_verification_session).permit :creator_id,
                                                        :missing_employees,
                                                        roster_verifications_attributes: [
                                                            :creator_id,
                                                            :person_id,
                                                            :status,
                                                            :location_id,
                                                            :last_shift_date,
                                                            :issue
                                                        ]
  end
end