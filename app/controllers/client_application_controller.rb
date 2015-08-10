class ClientApplicationController < BaseApplicationController
  layout 'client'

  before_action :set_current_client_representative,
                :check_client_rep

  def current_client_rep
    @current_client_representative ||= set_current_client_representative
  end

  private

  def set_current_client_representative
    client_rep_id = session[:client_representative_id] || return
    @current_client_representative = ClientRepresentative.find client_rep_id
  end

  def check_client_rep
    return if current_client_rep
    redirect_to new_session_client_representatives_path
  end

  def current_user
    current_client_rep
  end
end
