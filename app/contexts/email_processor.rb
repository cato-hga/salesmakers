class EmailProcessor
  def initialize(email)
    @email = email
  end

  def email
    @email
  end

  def process
    for attachment in email.attachments do
      acceptor(attachment)
    end
  end

  def acceptor(attachment)
    return unless attachment
    tempfile = create_tempfile(attachment)
    if tempfile.path.downcase.include?('uqube')
      VonageAccountStatusChangesImporter.new(tempfile)
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