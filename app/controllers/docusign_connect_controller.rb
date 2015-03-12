class DocusignConnectController < ApplicationController
  layout false
  protect_from_forgery except: :incoming

  skip_before_action CASClient::Frameworks::Rails::Filter
  skip_before_action :set_current_user,
                     :check_active,
                     :get_projects,
                     :setup_default_walls,
                     :set_last_seen,
                     :set_last_seen_profile,
                     :setup_new_publishables,
                     :filter_groupme_access_token,
                     :setup_accessibles,
                     :verify_authenticity_token

  def incoming
    data = Hash.from_xml request.raw_post
    envelope_id = get_envelope_id(data) || (render nothing: true, status: :unprocessable_entity and return)
    signed_time = get_signed_time(data) || (render nothing: true, status: :unprocessable_entity and return)
    mark_signed(envelope_id, signed_time)
    render nothing: true
  end

  private

  def get_envelope_id(data)
    envelope_info = data["DocuSignEnvelopeInformation"] || return
    time_zone_offset = envelope_info["TimeZoneOffset"] + '00'
    time_zone_offset.gsub!(/\-/, '-0')
    envelope_status = envelope_info["EnvelopeStatus"] || return
    envelope_status["EnvelopeID"]
  end

  def get_signed_time(data)
    envelope_info = data["DocuSignEnvelopeInformation"] || return
    time_zone_offset = envelope_info["TimeZoneOffset"] + '00'
    time_zone_offset.gsub!(/\-/, '-0')
    envelope_status = envelope_info["EnvelopeStatus"] || return
    recipient_statuses = envelope_status["RecipientStatuses"] || return
    return if recipient_statuses.empty?
    recipient_status_array = recipient_statuses["RecipientStatus"] || return
    return if recipient_status_array.empty?
    recipient_status = recipient_status_array[2]
    signed = recipient_status.has_key?('Signed') ? recipient_status['Signed'] : nil
    return unless signed
    Time.parse "#{signed} #{time_zone_offset}"
  end

  def mark_signed(envelope_id, signed_time)
    job_offer_detail = get_job_offer_detail(envelope_id) || return
    job_offer_detail.update completed: signed_time
    job_offer_detail.candidate.paperwork_completed!
  end

  def get_job_offer_detail(envelope_id)
    JobOfferDetail.find_by envelope_guid: envelope_id
  end
end