class AssetsMailer < ApplicationMailer
  default from: 'assetreturns@salesmakersinc.com'

  def recoup_mailer(device, person, notes)
    return unless device and person
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

  def separated_with_assets_mailer(person)
    @person_name = person.display_name
    @devices = person.devices
    if person.mobile_phone
      @person_phone = person.mobile_phone
    else
      @person_phone = 'N/A'
    end
    if person.personal_email
      @personal_email = person.personal_email
    else
      @personal_email = 'N/A'
    end
    mail(to: ['assets@retaildoneright.com', 'it@retaildoneright.com'],
         subject: "[SalesMakers] Separated Employee with Asset(s)"
    )
  end


  def separated_without_assets_mailer(person)
    @person_name = person.display_name
    if person.mobile_phone
      @person_phone = person.mobile_phone
    else
      @person_phone = 'N/A'
    end
    if person.personal_email
      @personal_email = person.personal_email
    else
      @personal_email = 'N/A'
    end
    mail(to: ['assets@retaildoneright.com', 'it@retaildoneright.com'],
         subject: "[SalesMakers] Separated Employee without Assets"
    )
  end

  def asset_return_mailer(person)
    @devices = person.devices
    @person_name = person.display_name
    if person.personal_email
      email = person.personal_email
    else
      email = ''
    end
    mail(to: ['assets@retaildoneright.com', email],
         subject: "[SalesMakers] Asset Return Instructions"
    )
  end

  def lost_or_stolen_mailer(device)
    if device.person #Only checking here because tests are a'failing otherwise
      person = device.person
      @person_name = person.display_name
      @device = device
      if person.mobile_phone
        @person_phone = person.mobile_phone
      else
        @person_phone = 'N/A'
      end
      if person.personal_email
        @personal_email = person.personal_email
      else
        @personal_email = 'N/A'
      end
      mail(to: ['assets@retaildoneright.com'],
           subject: "[SalesMakers] Deployed Asset Marked as Lost or Stolen"
      )
    end
  end

  def found_mailer(device)
    if device.person #Only checking here because tests are a'failing otherwise
      person = device.person
      @person_name = person.display_name
      @device = device
      if person.mobile_phone
        @person_phone = person.mobile_phone
      else
        @person_phone = 'N/A'
      end
      if person.personal_email
        @personal_email = person.personal_email
      else
        @personal_email = 'N/A'
      end
      mail(to: ['assets@retaildoneright.com'],
           subject: "[SalesMakers] Lost or Stolen Asset Marked as Found"
      )
    end
  end

end
