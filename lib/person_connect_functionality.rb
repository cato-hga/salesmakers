module PersonConnectFunctionality
  def self.return_from_connect_user(connect_user)
    person = Person.find_by connect_user_id: connect_user.id
    return person if person
    position = Position.return_from_connect_user connect_user
    person = Person.find_by_email connect_user.email
    creator = connect_user.createdby ? Person.find_by_connect_user_id(connect_user.createdby) : nil
    supervisor = connect_user.supervisor_id ? Person.find_by_connect_user_id(connect_user.supervisor_id) : nil
    return person if person
    Person.new_from_connect_user connect_user, position, supervisor, creator
  end

  def self.new_from_connect_user(connect_user, position, supervisor, creator)
    person = Person.new first_name: connect_user.firstname,
                        last_name: connect_user.lastname,
                        display_name: connect_user.name,
                        email: connect_user.username,
                        personal_email: connect_user.description,
                        connect_user_id: connect_user.id,
                        active: (connect_user.isactive == 'Y' ? true : false),
                        mobile_phone: connect_user.phone,
                        position: position,
                        supervisor: supervisor
    return nil unless person and person.save
    Person.log_onboard_from_connect person, creator
    person.add_area_from_connect
    person
  end

  def self.log_onboard_from_connect(person, creator)
    connect_user = person.connect_user
    LogEntry.person_onboarded_from_connect person, creator, connect_user.created, connect_user.updated
    LogEntry.position_set_from_connect person, creator, person.position, connect_user.created, connect_user.updated if person.position
  end

  def import_employment_from_connect
    return unless self.connect_user_id
    connect_user = self.connect_user
    bpartner = connect_user.connect_business_partner
    return unless bpartner
    salary_categories = bpartner.connect_business_partner_salary_categories
    return unless salary_categories
    employment_started = salary_categories.first
    return unless employment_started
    employment = Employment.new person: self,
                                start: employment_started.datefrom,
                                created_at: connect_user.created,
                                updated_at: employment_started.updated
    unless self.active?
      terminations = connect_user.connect_terminations
      ended = connect_user.updated.to_date
      terminated = ended
      ended = connect_user.lastcontact.to_date if connect_user.lastcontact
      reason = 'Not Recorded'
      if terminations and terminations.count > 0
        ended = terminations.first.last_day_worked
        terminated = terminations.first.created
        reason = terminations.first.connect_termination_reason.reason if terminations.first.connect_termination_reason
      end
      employment.end = ended
      employment.updated_at = terminated
      employment.end_reason = reason
    end
    employment.save
  end

  def return_person_area_from_connect
    return nil unless self.connect_user_id
    connect_user = ConnectUser.find_by ad_user_id: self.connect_user_id
    return nil unless connect_user
    area_name = Position.clean_area_name connect_user.region
    area_type = AreaType.determine_from_connect(connect_user, self.get_projects_hash, self.is_event?)
    PersonArea.return_from_name_and_type self, area_name, area_type, connect_user.leader?
  end

  def get_projects_hash
    connect_user = ConnectUser.find_by ad_user_id: self.connect_user_id
    return nil unless connect_user
    connect_user_project = connect_user.project
    return nil unless connect_user_project
    project_name = connect_user_project.name
    return {
        vonage: (project_name == 'Vonage'),
        sprint: (project_name == 'Sprint'),
        comcast: (project_name == 'Comcast')
    }
  end

  def is_event?
    connect_user = ConnectUser.find_by ad_user_id: self.connect_user_id
    return nil unless connect_user
    connect_user_region = connect_user.region
    return false unless connect_user_region
    connect_user_region.name.include? 'Event'
  end

  def add_area_from_connect
    PersonArea.where(person: self).destroy_all
    connect_user = ConnectUser.find_by ad_user_id: self.connect_user_id
    creator = Person.find_by_connect_user_id connect_user.createdby
    person_area = self.return_person_area_from_connect
    return unless person_area
    if person_area.save
      area = person_area.area
      leader = person_area.manages?
      return unless creator
      created_at = leader ? area.updated_at : connect_user.created
      if leader
        LogEntry.assign_as_manager_from_connect self, creator, person_area.area, created_at, created_at
      else
        LogEntry.assign_as_employee_from_connect self, creator, person_area.area, created_at, created_at
      end
    end
  end

  def separate_from_connect
    connect_user = get_connect_user || return
    self.update_subordinates
    self.update(active: false, updated_at: connect_user.updated)
    updated_to_inactive = self.active? ? false : true
    return updated_to_inactive if self.employments.count < 1
    employment = self.employments.first
    employment.end_from_connect
    updated_to_inactive
  end

  def update_subordinates
    for subordinate in self.employees do
      subordinate_connect_user = subordinate.connect_user
      next unless subordinate_connect_user
      PersonUpdater.new(subordinate_connect_user).update
    end
  end

  def update_address_from_connect
    return unless has_address?
    connect_address = self.connect_user.
        connect_business_partner.
        connect_business_partner_locations.
        first.
        connect_location
    connect_state = connect_address.connect_state
    return unless connect_address and connect_state
    new_address = PersonAddress.new person: self,
                                    line_1: connect_address.address1,
                                    line_2: connect_address.address2,
                                    city: connect_address.city,
                                    state: connect_state.name,
                                    zip: connect_address.postal
    return unless new_address.valid?
    self.person_addresses.where(physical: true).destroy_all
    new_address.save
  end

  def has_address?
    return false unless self.connect_user
    bp = self.connect_user.connect_business_partner
    return false unless bp
    locations = bp.connect_business_partner_locations
    return false unless locations.count > 0
    connect_address = locations.first.connect_location
    return false unless connect_address
    state = connect_address.connect_state
    return false unless state
    true
  end

  def get_connect_user
    ConnectUser.find_by username: self.email
  end

  def self.update_from_connect(minutes)
    connect_users = ConnectUser.where('updated >= ?', (Time.now - minutes.minutes).apply_eastern_offset)
    for connect_user in connect_users do
      PersonUpdater.new(connect_user).update
    end
  end
end