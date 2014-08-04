class API::V1::PeopleController < API::BaseController
  before_action :get_person, only: [:onboard, :separate]

  def onboard
    respond_with @person
  end

  def separate
    @person.separate_from_connect
    respond_with @person
  end

  private

  def get_person
    @connect_user = ConnectUser.find params[:connect_user_id]
    @person = Person.return_from_connect_user @connect_user || []
  end
end
