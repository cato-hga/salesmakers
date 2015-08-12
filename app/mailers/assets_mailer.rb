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

    handle_send to: ['assets@retaildoneright.com', email],
                subject: "[SalesMakers] Asset Returned"
  end

  def separated_with_assets_mailer(person)
    @person_name = person.display_name
    @devices = person.devices
    @eid = person.eid ? person.eid.to_s : 'N/A'
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
    @eid = person.eid ? person.eid.to_s : 'N/A'
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
    handle_send to: ['assets@retaildoneright.com', 'it@retaildoneright.com'],
                subject: "[SalesMakers] Separated Employee without Assets"
  end

  def asset_return_mailer(person)
    @devices = person.devices
    @person_name = person.display_name
    if person.personal_email
      email = person.personal_email
    else
      email = ''
    end
    handle_send to: ['assets@retaildoneright.com', email],
                subject: "[SalesMakers] Asset Return Instructions"
  end

  def lost_or_stolen_mailer(device)
    return unless device and device.person
    set_lost_stolen_or_found_variables device
    handle_send to: ['assets@retaildoneright.com'],
                subject: "[SalesMakers] Deployed Asset Marked as Lost or Stolen"
  end

  def found_mailer(device)
    return unless device and device.person
    set_lost_stolen_or_found_variables device
    handle_send to: ['assets@retaildoneright.com'],
                subject: "[SalesMakers] Lost or Stolen Asset Marked as Found"
  end

  def asset_approval_mailer(supervisor)
    return unless supervisor
    @supervisor = supervisor
    handle_send from: 'notifications@salesmakersinc.com',
                to: [supervisor.email],
                subject: "[SalesMakers] New Employees to Approve for Asset Deployment"
  end

  def asset_deployed(person, device_deployment)
    return unless person.email
    @person = person
    @device = device_deployment.device
    @device_deployment = device_deployment
    handle_send to: [@person.email, @person.personal_email],
                subject: "[SalesMakers] Your Asset is On Its Way!"
  end

  private

  def set_lost_stolen_or_found_variables device
    person = device.person
    @person_name = person.display_name
    @device = device
    @eid = person.eid ? person.eid.to_s : 'N/A'
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
  end

end
