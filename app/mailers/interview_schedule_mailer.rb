class InterviewScheduleMailer < ApplicationMailer
  default from: 'interviewscheduling@salesmakersinc.com'

  def interview_mailer(candidate, recruiter, schedule)
    @candidate = candidate
    @recruiter = recruiter
    @schedule = schedule
    #@cloud_room = cloud_room
    mail(to: candidate.email, cc: recruiter.email, subject: 'Your interview with SalesMakers, Inc')
  end
end