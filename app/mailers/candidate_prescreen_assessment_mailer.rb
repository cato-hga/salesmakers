class CandidatePrescreenAssessmentMailer < ApplicationMailer
  default from: 'personalityassessment@salesmakersinc.com'

  def assessment_mailer(candidate, area)
    @candidate = candidate
    @assessment_url = area.personality_assessment_url
    handle_send to: @candidate.email, subject: 'Your Sprint Personality Assessment Test'
  end

  def failed_assessment_mailer(candidate)
    @candidate = candidate
    handle_send to: @candidate.email, subject: 'Sprint Personality Assessment Notification'
  end
end