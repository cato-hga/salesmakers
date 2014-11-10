class API::V1::PeopleController < API::BaseController
  before_action :get_person, only: [:onboard, :separate, :update]

  #:nocov:
  def onboard
    creator = get_creator
    @person.import_employment_from_connect if @person
    if creator.log? :onboard,
                    @person,
                    nil,
                    @connect_user.created,
                    @connect_user.created
      @person.reload
      respond_with @person
    else
      respond_with Person.new
    end
  end

  def separate
    updater = get_updater
    unless @person.separate_from_connect
      respond_with Person.new
      return
    end
    last_contact = @connect_user.lastcontact
    separated = last_contact ? last_contact : Time.now
    updater.log? :separate,
                 @person,
                 nil,
                 separated,
                 separated
    @person.reload
    respond_with @person
  end

  def update
    updater = get_updater
    new_position = Position.return_from_connect_user(@connect_user)
    if new_position and @person.position != new_position
      if @person.update(position: new_position,
                        updated_at: @connect_user.updated)
        LogEntry.position_set_from_connect @person,
                                           updater,
                                           new_position,
                                           @connect_user.updated,
                                           @connect_user.updated
      end
    end
    new_person_area = @person.return_person_area_from_connect
    return unless new_person_area
    new_area = new_person_area.area
    new_leader = new_person_area.manages?
    old_person_areas = @person.person_areas
    old_person_area = old_person_areas.count > 0 ? old_person_areas.first : nil
    old_area = old_person_area ? old_person_area.area : nil
    old_leader = old_person_area ? old_person_area.manages? : false
    return unless new_area
    if new_area != old_area or new_leader != old_leader
      PersonArea.where(person: @person).destroy_all
      if new_person_area.save
        if new_leader
          LogEntry.assign_as_manager_from_connect @person, updater, new_area, @connect_user.updated, @connect_user.updated
        else
          LogEntry.assign_as_employee_from_connect @person, updater, new_area, @connect_user.updated, @connect_user.updated
        end
      end
    end
    if @person.email != @connect_user.username
      @person.email = @connect_user.username
      @person.save
    end
    @person.reload
    respond_with @person
  end

  private

  def get_person
    @connect_user = ConnectUser.find params[:connect_user_id]
    @person = Person.return_from_connect_user @connect_user || []
  end

  def get_creator
    creator_connect_user = @connect_user.creator
    Person.return_from_connect_user creator_connect_user || []
  end

  def get_updater
    updater_connect_user = @connect_user.updater
    Person.return_from_connect_user updater_connect_user || []
  end

  #:nocov:
end
