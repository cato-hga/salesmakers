class EmailAttachmentAcceptorJob < ActiveJob::Base
  queue_as :default

  def perform(file)
    if tempfile.path.downcase.include?('uqube')
      VonageAccountStatusChangesImporter.new(tempfile)
    end
  end
end
