class API::V1::PeopleController < API::BaseController
  before_action :get_person, only: [:onboard, :separate]

  def onboard
    creator = get_creator
    if creator.log? :onboard,
                    @person,
                    nil,
                    @connect_user.created,
                    @connect_user.created
      respond_with @person
    else
      respond_with Person.new
    end
  end

  def separate
    updater = get_updater
    unless @person.separate_from_connect
      respond with Person.new
      return
    end
    updater.log? :separate,
                 @person,
                 nil,
                 @connect_user.lastcontact,
                 @connect_user.lastcontact
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
end
