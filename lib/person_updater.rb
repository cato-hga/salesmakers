class PersonUpdater

  def initialize(connect_user)
    @connect_user = connect_user
    person = Person.return_from_connect_user @connect_user
    @person = person
    updater_connect_user = connect_user.updater
    @updater = Person.return_from_connect_user updater_connect_user
  end

  def update
    return unless @connect_user and @person and @updater
    update_position
    update_person_areas
    update_contact_info
    update_supervisor
    update_employees
    @person.update_address_from_connect
  end

  private

  def update_position
    new_position = Position.return_from_connect_user @connect_user
    if new_position and @person.position != new_position
      if @person.update position: new_position,
                       updated_at: @connect_user.updated
        LogEntry.position_set_from_connect @person,
                                           @updater,
                                           new_position,
                                           @connect_user.updated.apply_eastern_offset,
                                           @connect_user.updated.apply_eastern_offset
      end
    end
  end

  def update_person_areas
    old_person_areas = @person.person_areas
    old_person_area = old_person_areas.count > 0 ? old_person_areas.first : nil
    old_area = old_person_area ? old_person_area.area : nil
    old_leader = old_person_area ? old_person_area.manages? : false
    new_person_area = @person.return_person_area_from_connect
    return unless new_person_area
    new_area = new_person_area.area
    new_leader = new_person_area.manages?
    return unless new_area
    if new_area != old_area or new_leader != old_leader
      PersonArea.where(person: @person).destroy_all
      if new_person_area.save
        if new_leader
          LogEntry.assign_as_manager_from_connect @person,
                                                  @updater,
                                                  new_area,
                                                  @connect_user.updated.apply_eastern_offset,
                                                  @connect_user.updated.apply_eastern_offset
        else
          LogEntry.assign_as_employee_from_connect @person,
                                                   @updater,
                                                   new_area,
                                                   @connect_user.updated.apply_eastern_offset,
                                                   @connect_user.updated.apply_eastern_offset
        end
      end
    else
      @person.person_areas.delete(new_person_area)
    end
    true
  end

  def update_contact_info
    if @person.email != @connect_user.username
      @person.update email: @connect_user.username
    end
    connect_user_phone = @connect_user.phone.strip.gsub(/[^0-9]/, '')
    if @person.mobile_phone != connect_user_phone
      @person.update mobile_phone: connect_user_phone
    end
  end

  def update_supervisor
    begin
      supervisor_connect_user = @connect_user.supervisor
      supervisor = supervisor_connect_user ? Person.return_from_connect_user(supervisor_connect_user) : nil
      if supervisor != @person.supervisor
        @person.update supervisor: supervisor
      end
    rescue ActiveRecord::StatementInvalid
    end
  end

  def update_employees
    for employee in @person.employees do
      PersonUpdater.new(employee.connect_user).update
    end
    for connect_user in @connect_user.employees do
      employee = Person.return_from_connect_user connect_user
      PersonUpdater.new(connect_user).update if employee
    end
  end
end