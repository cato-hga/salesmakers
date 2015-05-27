module PersonConnectFunctionality
  def self.included(klass)
    klass.extend ClassMethods
  end

  def import_employment_from_connect
    connect_user = self.connect_user || return
    bpartner = connect_user.connect_business_partner || return
    salary_categories = bpartner.connect_business_partner_salary_categories || return
    employment_started = salary_categories.first || return
    employment = Employment.new person: self,
                                start: employment_started.datefrom,
                                created_at: connect_user.created,
                                updated_at: employment_started.updated
    terminate_if_inactive(employment, connect_user)
    employment.save
  end

  def terminate_if_inactive(employment, connect_user)
    return if self.active?
    termination = get_termination(connect_user)
    terminated = termination ? termination.created : connect_user.updated
    ended = get_employment_end_date(connect_user, termination)
    reason = termination ? termination.connect_termination_reason.reason : 'Not Recorded'
    employment.assign_attributes end: ended,
                                 updated_at: terminated.apply_eastern_offset.to_date,
                                 end_reason: reason
  end

  def get_termination(connect_user)
    terminations = connect_user.connect_terminations || return
    terminations.first
  end

  def get_employment_end_date(connect_user, termination)
    if termination
      termination.last_day_worked
    else
      connect_user.lastcontact ? connect_user.lastcontact : connect_user.updated.apply_eastern_offset.to_date
    end
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
        sprint_postpaid: (project_name == 'Sprint Postpaid'),
        comcast: (project_name == 'Comcast'),
        directv: (project_name == 'DirecTV')
    }
  end

  def is_event?
    connect_user = ConnectUser.find_by ad_user_id: self.connect_user_id
    return nil unless connect_user
    connect_user_region = connect_user.region
    return false unless connect_user_region
    connect_user_region.name.include? 'Event' or connect_user_region.name.include? 'Owned'
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
        LogEntry.assign_as_manager_from_connect self, creator, person_area.area, created_at.apply_eastern_offset, created_at.apply_eastern_offset
      else
        LogEntry.assign_as_employee_from_connect self, creator, person_area.area, created_at.apply_eastern_offset, created_at.apply_eastern_offset
      end
    end
  end

  def separate_from_connect(auto = false)
    connect_user = get_connect_user || return
    self.update_subordinates
    self.separate(connect_user.updated, auto)
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

  module ClassMethods
    def return_from_connect_user(connect_user)
      person = Person.find_by connect_user_id: connect_user.id
      return person if person
      position = Position.return_from_connect_user connect_user
      person = Person.find_by_email connect_user.email
      creator = connect_user.createdby ? Person.find_by_connect_user_id(connect_user.createdby) : nil
      supervisor = connect_user.supervisor_id ? Person.find_by_connect_user_id(connect_user.supervisor_id) : nil
      return person if person
      Person.new_from_connect_user connect_user, position, supervisor, creator
    end

    def new_from_connect_user(connect_user, position, supervisor, creator)
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

    def log_onboard_from_connect(person, creator)
      connect_user = person.connect_user
      LogEntry.person_onboarded_from_connect person, creator, connect_user.created.apply_eastern_offset, connect_user.updated.apply_eastern_offset
      LogEntry.position_set_from_connect person, creator, person.position, connect_user.created.apply_eastern_offset, connect_user.updated.apply_eastern_offset if person.position
    end

    def update_from_connect(minutes)
      connect_users = ConnectUser.where('updated >= ?', (Time.now - minutes.minutes).apply_eastern_offset)
      for connect_user in connect_users do
        PersonUpdater.new(connect_user).update
      end
      ProcessLog.create process_class: self.class.name, records_processed: connect_users.count, notes: "update_from_connect(#{minutes.to_s})"
    end

    def update_eids_from_connect
      ids = ConnectUserMapping.employee_ids
      count = 0
      for eid in ids do
        person = Person.find_by_connect_user_id eid.ad_user_id
        next if not person or person.eid == eid.mapping.to_i
        count += 1 if person.update(eid: eid.mapping.to_i)
      end
      ProcessLog.create process_class: self.class.name, records_processed: count, notes: "update_eids_from_connect"
    end

    def update_eids_from_connect_blueforce_usernames
      username_mappings = ConnectUserMapping.blueforce_usernames
      count = 0
      for username_mapping in username_mappings do
        person = Person.find_by_connect_user_id username_mapping.ad_user_id
        next if not person or person.eid
        count += 1 if person.update(eid: username_mapping.mapping.gsub(/[^0-9]/, '').to_i)
      end
      ProcessLog.create process_class: self.class.name,
                        records_processed: count,
                        notes: "update_eids_from_connect_blueforce_usernames"
    end
  end
end