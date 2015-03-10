require 'rails_helper'

describe InterviewScheduleMailer do
  include DateAndTimeHelperExtension

  describe 'interview_mailer' do
    let(:candidate) { create :candidate }
    let(:recruiter) { create :person, position: position }
    let(:position) {
      create :position,
             name: 'Advocate',
             hq: true
    }

    let(:cloud_room) { '357145' }
    let(:schedule) { create :interview_schedule }
    let(:mail) { InterviewScheduleMailer.interview_mailer(candidate, recruiter, schedule, cloud_room) }

    it 'has the correct from address' do
      expect(mail.from).to include('interviewscheduling@salesmakersinc.com')
    end
    it 'has the correct subject' do
      expect(mail.subject).to include('Your interview with SalesMakers, Inc')
    end
    it 'sends an email to the candidate, CC recruiter' do
      expect(mail.to).to include(candidate.email)
      expect(mail.cc).to include(recruiter.email)
    end
    it 'includes the correct interview time and date' do
      expect(mail.body).to include(schedule.start_time.strftime('%l:%M %p %Z'))
      expect(mail.body).to include(long_date(schedule.interview_date))
    end
    it 'includes lifesize cloud instructions' do
      expect(mail.body).to include('client.lifesizecloud.com')
      expect(mail.body).to include('Android')
      expect(mail.body).to include('IOS')
    end
    it 'includes the correct lifesize cloud room' do
      expect(mail.body).to include(cloud_room)
    end
  end
end