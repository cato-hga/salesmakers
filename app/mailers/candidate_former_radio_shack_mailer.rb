class CandidateFormerRadioShackMailer < ApplicationMailer
  default from: 'sprintcandidatevetting@salesmakersinc.com'

  def vetting_mailer(candidate, start_date, end_date, location)
    @name = candidate.name
    @start_date = start_date
    @end_date = end_date
    @location = location
    mail(to: 'smiles@retaildoneright.com',
         #cc: ['kevin@retaildoneright.com', 'rcushing@retaildoneright.com'],
         subject: 'New SalesMakers, Inc Candidate Requiring Approval'
    )
  end
end
