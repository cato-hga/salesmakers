require 'rails_helper'

describe CandidatePrescreenAssessmentMailer do

  describe 'prescreen mailer' do
    let(:candidate) { create :candidate }
    let(:area) { create :area, personality_assessment_url: link }
    let(:mail) { CandidatePrescreenAssessmentMailer.assessment_mailer(candidate, area) }
    let!(:link) { 'https://google.com' }
    it 'has the correct from address' do
      expect(mail.from).to include('personalityassessment@salesmakersinc.com')
    end
    it 'has the correct subject' do
      expect(mail.subject).to include('Your Sprint Personality Assessment Test')
    end
    it 'sends an email to the candidate' do
      expect(mail.to).to include(candidate.email)
    end
    it 'contains a link to the personality assessment test' do
      expect(mail.body).to include(link)
    end
  end

  describe 'failed_assessment_mailer' do
    let(:candidate) { create :candidate }
    let(:mail) { CandidatePrescreenAssessmentMailer.failed_assessment_mailer(candidate) }
    it 'has the correct from address' do
      expect(mail.from).to include('personalityassessment@salesmakersinc.com')
    end
    it 'has the correct subject' do
      expect(mail.subject).to include('Sprint Personality Assessment Notification')
    end
    it 'sends an email to the candidate' do
      expect(mail.to).to include(candidate.email)
    end
  end
end