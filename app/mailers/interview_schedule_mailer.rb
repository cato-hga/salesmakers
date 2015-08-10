class InterviewScheduleMailer < ApplicationMailer
  default from: 'interviewscheduling@salesmakersinc.com'

  def interview_mailer(candidate, recruiter, schedule, cloud_room)
    @candidate = candidate
    @recruiter = recruiter
    @schedule = schedule
    @cloud_room = cloud_room
    handle_send to: candidate.email, cc: recruiter.email, subject: 'Your interview with SalesMakers, Inc'
  end

  def interview_now_mailer(candidate, recruiter, schedule, cloud_room)
    @candidate = candidate
    @recruiter = recruiter
    @schedule = schedule
    @cloud_room = cloud_room
    handle_send to: candidate.email, cc: recruiter.email, subject: 'Your interview with SalesMakers, Inc'
  end
end