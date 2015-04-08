class API::V1::PeopleController < API::BaseController

  #:nocov:
  def onboard
    creator = get_creator
    get_person.import_employment_from_connect if get_person

    if creator.log? :onboard,
                    get_person,
                    nil,
                    connect_user.created,
                    connect_user.created
      PersonUpdaterJob.perform_later connect_user.id
      get_person.reload
      if connect_user.connect_user_mappings and
          connect_user.connect_user_mappings.blueforce_usernames and
          connect_user.connect_user_mappings.blueforce_usernames.first and
          connect_user.connect_user_mappings.blueforce_usernames.first.mapping.present?
        connect_user.text_blueforce_credentials
      end
      respond_with get_person
    else
      respond_with Person.new
    end
  end

  def separate
    return unless get_person
    updater = get_updater
    unless get_person.separate_from_connect
      respond_with Person.new
      return
    end
    last_contact = connect_user.lastcontact
    separated = last_contact ? last_contact.remove_eastern_offset : Time.now
    updater.log? :separate,
                 get_person,
                 nil,
                 separated,
                 separated
    PersonUpdaterJob.perform_later connect_user.id
    get_person.reload
    respond_with get_person
  end

  def update
    respond_with nil and return if connect_user.firstname == 'X'
    respond_with nil and return unless get_person
    # updater = get_updater
    # new_position = Position.return_from_connect_user(connect_user)
    # if new_position and get_person.position != new_position
    #   if get_person.update(position: new_position,
    #                        updated_at: connect_user.updated)
    #     LogEntry.position_set_from_connect get_person,
    #                                        updater,
    #                                        new_position,
    #                                        connect_user.updated,
    #                                        connect_user.updated
    #   end
    # end
    # new_person_area = get_person.return_person_area_from_connect
    # respond_with get_person and return unless new_person_area
    # new_area = new_person_area.area
    # new_leader = new_person_area.manages?
    # old_person_areas = get_person.person_areas
    # old_person_area = old_person_areas.count > 0 ? old_person_areas.first : nil
    # old_area = old_person_area ? old_person_area.area : nil
    # old_leader = old_person_area ? old_person_area.manages? : false
    # respond_with get_person and return unless new_area
    # if new_area != old_area or new_leader != old_leader
    #   PersonArea.where(person: get_person).destroy_all
    #   if new_person_area.save
    #     if new_leader
    #       LogEntry.assign_as_manager_from_connect get_person, updater, new_area, connect_user.updated, connect_user.updated
    #     else
    #       LogEntry.assign_as_employee_from_connect get_person, updater, new_area, connect_user.updated, connect_user.updated
    #     end
    #   end
    # end
    # if get_person.email != connect_user.username
    #   get_person.email = connect_user.username
    #   get_person.save
    # end
    connect_user = get_person.connect_user
    respond_with(get_person) and return unless connect_user
    PersonUpdaterJob.perform_later connect_user.id
    respond_with Person.return_from_connect_user(connect_user)
  end

  private

  def get_person
    if @person
      @person
    else
      @person = Person.return_from_connect_user connect_user || []
    end
  end

  def get_creator
    creator_connect_user = connect_user.creator
    Person.return_from_connect_user creator_connect_user || []
  end

  def get_updater
    updater_connect_user = connect_user.updater
    Person.return_from_connect_user updater_connect_user || []
  end

  def connect_user
    if @connect_user
      @connect_user
    else
      @connect_user = ConnectUser.find params[:connect_user_id]
    end
  end

  #:nocov:
end
