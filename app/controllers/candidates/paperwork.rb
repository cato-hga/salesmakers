module Candidates::Paperwork
  def send_paperwork
    geocode_if_necessary
    if Rails.env.staging? or Rails.env.development? or Rails.env.test?
      envelope_response = 'STAGING'
    else
      envelope_response = DocusignTemplate.send_nhp @candidate, @current_person
    end
    @candidate.job_offer_details.destroy_all
    job_offer_details = JobOfferDetail.new candidate: @candidate,
                                           sent: DateTime.now
    if envelope_response
      job_offer_details.envelope_guid = envelope_response
      flash[:notice] = 'Paperwork sent successfully.'
    else
      flash[:error] = 'Could not send paperwork automatically. Please send now manually.'
    end
    job_offer_details.save
    @candidate.paperwork_sent!
    redirect_to @candidate
  end
end