class DeviceRecoupMailer < ApplicationMailer
  def recoup_mailer(device, person)
    mail(to: ['assets@retaildoneright.com',
              person.personal_email],
         subject: "[NEW RBDC - Ignore] Asset Returned"
    )
  end
end
