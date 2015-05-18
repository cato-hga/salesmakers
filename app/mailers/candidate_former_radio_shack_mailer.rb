class CandidateFormerRadioShackMailer < ApplicationMailer
  default from: 'sprintvetting@salesmakersinc.com'

  def vetting_mailer(candidate, start_date, end_date, location)
    @name = candidate.name
    @start_date = start_date
    @end_date = end_date
    @location = location
    mail(to: ['kevin@retaildoneright.com', 'rcushing@retaildoneright.com'],
         subject: 'New SalesMakers, Inc Candidate Requiring Approval'
    )
    # mail(to: 'kelly.berard@radioshack.com',
    #      cc: ['kevin@retaildoneright.com', 'rcushing@retaildoneright.com'],
    #      subject: 'New SalesMakers, Inc Candidate Requiring Approval'
    # )
  end
end