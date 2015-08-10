class EmailAttachmentAcceptorJob < ActiveJob::Base
  queue_as :default

  def perform(file)
    if file.downcase.include?('uqube')
      VonageAccountStatusChangesImporter.new(file)
    elsif file.downcase.include?('candidate_score')
      SprintPersonalityAssessmentProcessing.new(file)
    end
  end
end