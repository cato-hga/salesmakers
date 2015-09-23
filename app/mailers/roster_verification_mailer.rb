class RosterVerificationMailer < ApplicationMailer
  default from: "managerial@salesmakersinc.com"

  def send_notification_and_link(person)
    @person = person
    @managed_team_members = person.directly_managed_team_members
    if @managed_team_members.count > 1
      mail to: person.email,
           subject: 'Please Verify Your Roster'
    else
      return
    end
  end

  def send_employee_exceptions roster_verification_session
    @unknown_employees = roster_verification_session.roster_verifications.where status: RosterVerification.statuses[:issue]
    @missing_employees = roster_verification_session.missing_employees
    return if @unknown_employees.empty?
    @creator = roster_verification_session.creator
    person_areas = @creator.person_areas
    return if person_areas.empty?
    project = person_areas.first.area.project
    to_address = project_emails.andand[project.name] || return
    mail to: to_address,
         cc: @creator.email,
         subject: "#{@creator.display_name}'s Exceptions on Roster Verification"
  end

  private

  def project_emails
    {
        'Sprint Prepaid' => 'sprintstaffing@retaildoneright.com',
        'STAR' => 'sprintradioshack@salesmakersinc.com',
        'Comcast Retail' => 'comcaststaffing@salesmakersinc.com',
        'DirecTV Retail' => 'directvstaffing@salesmakersinc.com',
        'Vonage Events' => 'fieldhires@retaildoneright.com',
        'Vonage' => 'fieldhires@retaildoneright.com'
    }
  end

end
