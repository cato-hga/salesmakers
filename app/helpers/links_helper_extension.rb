module LinksHelperExtension
  def person_area_links(person, classes = [])
    links = Array.new
    for area in person.areas do
      links << area_link(area)
    end
    links.join(', ').html_safe
  end

  def area_link(area)
    link_to area.name, management_scorecard_client_project_area_url(area.project.client, area.project, area)
  end

  def department_link(department)
    link_to department.name, department
  end

  def project_link(project)
    #link_to project.name, [project.client, project]
    image_tag("/images/#{project.name.gsub(' ', '').underscore}_logo_transparent_32x32.png",
              class: [:inline_logo]).html_safe +
        "&nbsp;".html_safe +
        project.name
  end

  def client_link(client)
    client.name
  end

  def phone_link(phone, classes = nil)
    return if phone.blank?
    phone_string = phone.to_s
    link_to '(' + phone_string[0..2] + ') ' + phone_string[3..5] + '-' + phone_string[6..9], 'tel:' + phone_string, class: classes
  end

  def csv_link(path, record_count)
    if record_count >= 1000
      data_attributes = {
          confirm: 'Exporting this many records could take a while. After clicking OK, please wait for the export to complete.',
          attachment: true
      }
    else
      data_attributes = { attachment: true }
    end
    link_to 'csv', path, class: [:button, :inline_button], data: data_attributes
  end

  def email_link(email, classes = nil)
    return unless email
    mail_to email, email, classes: classes
  end

  def line_state_links(line)
    links = Array.new
    for state in line.line_states do
      links << link_to(state.name, line)
    end
    links.join(', ').html_safe
  end

  def device_state_links(device)
    links = Array.new
    for state in device.device_states do
      links << link_to(state.name, device)
    end
    links.join(', ').html_safe
  end

  def person_link(person, classes = nil)
    person = Person.find(person) if person.is_a?(Integer)
    classes = tack_on_inactive_class(person, classes)
    link = link_to person.display_name, person_url(person), class: classes
    if can_send_text?(person)
      link = link + contact_link(person)
    end
    link
  end

  def can_send_text?(person)
    person.mobile_phone and
        not person.mobile_phone.include? '8005551212' and
        person.show_details_for_ids? @visible_people_ids and
        @current_person and
        @current_person.position and
        @current_person.position.hq?
  end

  def contact_link(person)
    link_to icon('megaphone'), new_sms_message_person_url(person), class: [:send_contact]
  end

  def candidate_contact_link(candidate)
    return unless candidate.mobile_phone_valid? && !candidate.mobile_phone_is_landline?
    link_to icon('megaphone'), new_sms_message_candidate_url(candidate), class: [:send_contact]
  end

  def person_sales_link(person, classes = nil)
    classes = tack_on_inactive_class(person, classes)
    link_to NameCase(person.display_name), sales_person_url(person), class: classes
  end

  def tack_on_inactive_class(object, classes)
    if classes and classes.is_a? String
      classes = [classes]
    end
    extra_classes = object.active? ? [] : [:inactive]
    if classes
      classes = classes.zip(extra_classes).flatten.compact.uniq
    else
      classes = extra_classes
    end
    classes
  end

  def area_sales_link(area, classes = '')
    link_to area.name, sales_client_project_area_url(area.project.client, area.project, area), class: classes
  end

  def device_link(device)
    link_to device.serial, device
  end

  def location_link(project, location)
    link_to location.name, client_project_location_path(project.client, project, location)
  end

  def vonage_sale_link vonage_sale
    link_to vonage_sale.mac, vonage_sale
  end

  def tracking_link(tracking_number, text = nil)
    if text == nil
      text = tracking_number
    end
    link_to text, 'http://www.fedex.com/Tracking?action=track&tracknumbers=' + tracking_number, target: '_blank'
  end

  def line_link(line, classes = nil)
    classes = tack_on_inactive_class(line, classes)
    line_string = line.identifier
    return line_string unless line_string.length == 10
    link_to '(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9], line, class: classes
  end

  def line_display(line)
    line_string = line.identifier
    return line_string unless line_string.length == 10
    '(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9]
  end

  def comcast_customer_link(comcast_customer, classes = nil)
    return unless comcast_customer
    link_to comcast_customer.name, comcast_customer_path(comcast_customer), class: classes
  end

  def directv_customer_link(directv_customer, classes = nil)
    return unless directv_customer
    link_to directv_customer.name, directv_customer_path(directv_customer), class: classes
  end

  def candidate_link(candidate, classes = nil)
    classes = tack_on_inactive_class(candidate, classes)
    link = link_to candidate.name, candidate_url(candidate), class: classes
    if candidate.mobile_phone &&
        @current_person &&
        @current_person.position &&
        @current_person.position.hq?
      link = link + candidate_contact_link(candidate)
    end
    link
  end
end