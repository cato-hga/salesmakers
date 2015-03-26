class EmailAttachmentAcceptorJob < ActiveJob::Base
  queue_as :default

  def perform(file)
    if file.downcase.include?('uqube')
      VonageAccountStatusChangesImporter.new(file)
    end
  end
end