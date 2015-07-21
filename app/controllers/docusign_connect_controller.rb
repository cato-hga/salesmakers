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
    if JobOfferDetail.where(envelope_guid: envelope_id)
      nhp(data, envelope_id); return if performed?
    end
  end

  def nhp(data, envelope_id)
    candidate_signed_time = get_signed_time(data, 0) || (render nothing: true, status: :unprocessable_entity and return)
    advocate_signed_time = get_signed_time(data, 1)
    hr_signed_time = get_signed_time(data, 2)
    Rails.logger.debug "HR: #{hr_signed_time}"
    Rails.logger.debug "Advocate: #{advocate_signed_time}"
    Rails.logger.debug "Candidate: #{candidate_signed_time}"
    mark_nhp_signed(envelope_id, candidate_signed_time, advocate_signed_time, hr_signed_time)
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

  def get_signed_time(data, position)
    envelope_info = data["DocuSignEnvelopeInformation"] || return
    time_zone_offset = envelope_info["TimeZoneOffset"] + '00'
    time_zone_offset.gsub!(/\-/, '-0')
    envelope_status = envelope_info["EnvelopeStatus"] || return
    recipient_statuses = envelope_status["RecipientStatuses"] || return
    return if recipient_statuses.empty?
    recipient_status_array = recipient_statuses["RecipientStatus"] || return
    return if recipient_status_array.empty?
    recipient_status = recipient_status_array[position] || return
    return unless recipient_status.is_a?(Hash)
    signed = recipient_status.has_key?('Signed') ? recipient_status['Signed'] : nil
    return unless signed
    Time.parse "#{signed} #{time_zone_offset}"
  end

  def mark_nhp_signed(envelope_id, candidate_signed_time, advocate_signed_time, hr_signed_time)
    job_offer_detail = get_job_offer_detail(envelope_id) || return
    candidate = job_offer_detail.candidate || return
    person = Person.find_by display_name: 'System Administrator'
    if hr_signed_time
      job_offer_detail.update completed: hr_signed_time,
                              completed_by_advocate: advocate_signed_time,
                              completed_by_candidate: candidate_signed_time
      person.log? "signed_nhp",
                  job_offer_detail,
                  candidate,
                  nil,
                  nil,
                  'HR'
      candidate.paperwork_completed_by_hr! unless candidate.onboarded?
    elsif advocate_signed_time
      job_offer_detail.update completed: nil,
                              completed_by_advocate: advocate_signed_time,
                              completed_by_candidate: candidate_signed_time
      person.log? "signed_nhp",
                  job_offer_detail,
                  candidate,
                  nil,
                  nil,
                  'Advocate'
      candidate.paperwork_completed_by_advocate!
    elsif candidate_signed_time
      job_offer_detail.update completed: nil,
                              completed_by_advocate: nil,
                              completed_by_candidate: candidate_signed_time
      person.log? "signed_nhp",
                  job_offer_detail,
                  candidate,
                  nil,
                  nil,
                  'Candidate'
      candidate.paperwork_completed_by_candidate!
    end
  end

  def get_job_offer_detail(envelope_id)
    JobOfferDetail.find_by envelope_guid: envelope_id
  end
end