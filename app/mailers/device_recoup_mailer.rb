class DeviceRecoupMailer < ApplicationMailer
  def recoup_mailer(device, person, notes)
    @device = device
    @person = person
    @notes = notes
    @line = device.line
    mail(to: ['assets@retaildoneright.com',
              @person.personal_email],
         subject: "[NEW RBDC - Ignore] Asset Returned"
    )
  end
end
