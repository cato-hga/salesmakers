class EmailProcessor
  def initialize(email)
    @email = email
  end

  def email
    @email
  end

  def process
    for attachment in email.attachments do
      EmailAttachmentAcceptorJob.perform_later attachment
    end
  end
end