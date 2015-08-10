class ClientRepresentativesController < ClientApplicationController
  skip_before_action :set_current_client_representative
  skip_before_action :check_client_rep, only: [:new_session, :create_session]
  skip_before_action :verify_authenticity_token, only: [:destroy_session]

  def new_session
  end

  def create_session
    client_representative = ClientRepresentative.find_by email: params.andand[:session].andand[:email].andand.downcase
    if not client_representative.nil? and client_representative.authenticate(params.andand[:session].andand[:password])
      session[:client_representative_id] = client_representative.id
      flash[:notice] = 'Successfully logged in.'
      redirect_to welcome_client_representatives_path
    else
      flash[:error] = 'Incorrect email or password'
      render :new_session
    end
  end

  def destroy_session
    session.delete(:client_representative_id)
    @client_representative = nil
    redirect_to new_session_client_representatives_path
  end

  def welcome
  end

end