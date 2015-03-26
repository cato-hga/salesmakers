class EmailProcessor
  def initialize(email)
    @email = email
  end

  def email
    @email
  end

  def process
    for attachment in email.attachments do
      next unless attachment
      tempfile = create_tempfile(attachment)
      EmailAttachmentAcceptorJob.perform_later File.absolute_path(tempfile.path)
    end
  end

  def create_tempfile(attachment)
    downcase_filename = attachment.original_filename.downcase
    ext = File.extname(downcase_filename)
    tempfile = attachment.tempfile
    return tempfile if tempfile.path[ext.length*-1, tempfile.path.length] == ext
    tempfilename = "#{tempfile.path}#{ext}"
    File.rename tempfile.path, tempfilename
    File.new tempfilename
  end
end