class RosterVerificationDocusignJob < ActiveJob::Base
  queue_as :default

  def perform roster_verification_session
    for roster_verification in roster_verification_session.roster_verifications do
      if roster_verification.status == 'terminate'
        nos_envelope = DocusignTemplate.send_blank_nos roster_verification.person, roster_verification.creator
        roster_verification.update envelope_guid: nos_envelope if nos_envelope
      end
    end
  end
end