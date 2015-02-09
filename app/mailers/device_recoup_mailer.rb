class DeviceRecoupMailer < ApplicationMailer
  default from: 'assetreturns@salesmakersinc.com'

  def recoup_mailer(device, person, notes)
    @device = device
    @notes = notes
    @person_name = person.display_name

    if person.mobile_phone
      @person_phone = person.mobile_phone
    else
      @person_phone = 'N/A'
    end

    if person.personal_email
      @personal_email = person.personal_email
      email = person.personal_email
    else
      @personal_email = 'N/A'
      email = ''
    end

    if device.line
      line = device.line
      @line = line.identifier
    else
      @line = 'N/A'
    end

    mail(to: ['assets@retaildoneright.com', email],
         subject: "[SalesMakers] Asset Returned"
    )
  end
end
