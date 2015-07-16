class RosterVerificationDocusignJob < ActiveJob::Base
  queue_as :default

  def perform roster_verification_session
    for roster_verification in roster_verification_session.roster_verifications do
      DocusignTemplate.send_blank_paf roster_verification.person, roster_verification.creator if roster_verification.status == 'PAF'
      DocusignTemplate.send_blank_nos roster_verification.person, roster_verification.creator if roster_verification.status == 'NOS'
    end
  end
end