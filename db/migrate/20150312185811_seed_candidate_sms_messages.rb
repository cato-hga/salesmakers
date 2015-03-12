class SeedCandidateSMSMessages < ActiveRecord::Migration
  def change
    CandidateSMSMessage.create text: 'Hi. I am a recruiter with SalesMakers, Inc.  I just called and left you a voicemail regarding your resume.  Please return my call at your earliest convenience.',
                               active: true
    CandidateSMSMessage.create text: 'This is a reminder that you have a scheduled interview with SalesMakers today.  If you need to reschedule or cancel, please call my office.',
                               active: true
    CandidateSMSMessage.create text: 'Congratulations on your new job with SalesMakers, Inc.  Your new hire paperwork has been delivered to your e-mail.  Please complete as soon as possible.',
                               active: true
    CandidateSMSMessage.create text: 'This is a reminder that you are scheduled to attend SalesMaker training today.  If you are unable to attend, please contact your supervisor immediately.',
                               active: true
  end
end
