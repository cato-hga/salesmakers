module Candidates::SMSMessages
  def new_sms_message
    if @candidate.mobile_phone.length != 10
      flash[:error] = "Sorry, but the candidate's phone number is not " +
          "10 digits long. Please correct the phone number to send text messages"
      redirect_to :back and return
    end
    @messages = CandidateSMSMessage.all
  end

  def create_sms_message
    message = sms_message_params[:contact_message]
    gateway = Gateway.new '+18133441170'
    gateway.send_text_to_candidate @candidate, message, @current_person
    flash[:notice] = 'Message successfully sent.'
    redirect_to candidate_path(@candidate)
  end

  private

  def sms_message_params
    params.permit :contact_message
  end
end