class RosterVerificationMailer < ApplicationMailer
  default from: "notifications@salesmakersinc.com"

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

end
