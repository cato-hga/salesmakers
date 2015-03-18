class CandidatePrescreenAssessmentMailer < ApplicationMailer
  default from: 'personalityassessment@salesmakersinc.com'

  def assessment_mailer(candidate, area)
    @candidate = candidate
    @assessment_url = area.personality_assessment_url
    mail(to: @candidate.email, subject: 'Your Sprint Personality Assessment Test')
  end
end