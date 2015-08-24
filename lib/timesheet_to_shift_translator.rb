module TimesheetToShiftTranslator
  def translate_all(connect_timesheets)
    @unmatched_timesheets = []
    shifts = Array.new
    connect_timesheets.each do |timesheet|
      shift = translate(timesheet)
      shifts << shift if shift
    end
    shifts.uniq
  end

  def translate(timesheet)
    shift = Shift.new person: get_person(timesheet.ad_user_id),
                      location: get_location(timesheet.c_bpartner_location_id),
                      date: timesheet.shift_date.to_date,
                      hours: calculate_hours(timesheet),
                      break_hours: calculate_breaks(timesheet),
                      training: is_training?(timesheet),
                      meeting: is_meeting?(timesheet),
                      project: get_project(timesheet)
    add_to_unmatched(timesheet, shift) unless shift.valid?
    shift
  end

  def calculate_hours(timesheet)
    hours = timesheet.hours
    hours += timesheet.overtime if timesheet.respond_to?(:overtime)
    hours
  end

  def calculate_breaks(timesheet)
    breaks = 0.0
    breaks += timesheet.time_docked if timesheet.respond_to?(:time_docked)
    breaks
  end

  def is_training? timesheet
    is_training = false
    if timesheet.connect_business_partner_location && timesheet.connect_business_partner_location.name.downcase.include?('training')
      is_training = true
    end
    if timesheet.respond_to?(:customer) && timesheet.customer
      is_training = timesheet.customer.downcase.include?('training') ? true : is_training
    elsif timesheet.respond_to?(:site_name) && timesheet.site_name
      is_training = timesheet.site_name.downcase.include?('training') ? true : is_training
    end
    is_training
  end

  def is_meeting? timesheet
    is_meeting = false
    if timesheet.connect_business_partner_location && timesheet.connect_business_partner_location.name.downcase.include?(' meeting')
      is_meeting = true
    end
    if timesheet.respond_to?(:customer) && timesheet.customer
      is_meeting = timesheet.customer.downcase.include?('meeting') ? true : is_meeting
    elsif timesheet.respond_to?(:site_name) && timesheet.site_name
      is_meeting = timesheet.site_name.downcase.include?('meeting') ? true : is_meeting
    end
    is_meeting
  end

  def get_person(ad_user_id)
    Person.find_by connect_user_id: ad_user_id
  end

  def get_location(c_bpartner_location_id)
    c_bpl = ConnectBusinessPartnerLocation.find_by c_bpartner_location_id: c_bpartner_location_id
    return nil unless c_bpl
    Location.return_from_connect_business_partner_location c_bpl
  end

  def get_project timesheet
    timesheet.project
  end

  def unmatched_timesheets
    @unmatched_timesheets
  end

  private

  def add_to_unmatched(timesheet, shift)
    if timesheet &&
        ((timesheet.respond_to?(:site_num) &&
            timesheet.site_num != 'CORP' &&
            timesheet.site_num != 'CALLCENTERHQ' &&
            timesheet.site_num != 'HRHQ' &&
            timesheet.site_num != 'SMSCORP' &&
            timesheet.site_num != 'OPSHQ' &&
            timesheet.site_num != 'RECRUITHQ') ||
            !timesheet.respond_to?(:site_num)
        ) &&
        timesheet.hours > 0
      @unmatched_timesheets << {
          timesheet: timesheet,
          reason: shift.errors.full_messages.join(', ')
      }
    end
  end
end