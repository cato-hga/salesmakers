class VonageEmailDestination
  def initialize file_basename, headers
    @headers = headers
    @file_basename = file_basename
    csv_tempfile = Tempfile.new([file_basename, '.csv'])
    @csv_file = File.new(csv_tempfile.path)
    @csv = CSV.open @csv_file, 'w'
  end

  def write row
    puts row.inspect
    unless @headers_written
      @headers_written = true
      @csv << @headers
    end
    @csv << row
  end

  def close
    @csv.close

    send_file
  end

  private

  def send_file
    to = [
        'april.gonzalez@vonage.com',
        'jennifer.trace@vonage.com',
        'charris@retaildoneright.com',
        'aatkinson@salesmakersinc.com'
    ]
    NotificationMailer.simple_mail(to,
                                   "[SalesMakers] 32-Day Retail Data - #{Date.current.strftime('%m/%d/%Y')}",
                                   "See attachments(s). Confidential. For intended recipients only.",
                                   false,
                                   [@csv_file.path]
    ).deliver_later
  end
end