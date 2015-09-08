require 'gpgme'
require 'net/sftp'

class UQubeDestination
  def initialize file_basename, headers
    @headers = headers
    @file_basename = file_basename
    csv_tempfile = Tempfile.new([file_basename, '.csv'])
    txt_tempfile = Tempfile.new([file_basename, '.txt'])
    @csv_file = File.new(csv_tempfile.path)
    @txt_file = File.new(txt_tempfile.path)
    @csv = CSV.open @csv_file, 'w'
    @txt = CSV.open @txt_file, 'w', col_sep: '|', quote_char: "\x00"
  end

  def write row
    puts row.inspect
    unless @headers_written
      @headers_written = true
      @csv << @headers
      @txt << @headers
    end
    @csv << row
    @txt << row
  end

  def close
    @csv.close
    @txt.close

    upload_file
    send_csv_as_attachment
  end

  private

  def upload_file
    encrypted_file = encrypt_file
    Net::SFTP.start('ftp.uqube.com', 'RBD', password: '*7Rbdq!') do |sftp|
      sftp.upload! encrypted_file.path, "/#{@file_basename}.pgp"
    end
  end

  def encrypt_file
    pgp_key_path = Rails.root.join('vendor', 'upperquadrant.key').to_s
    GPGME::Key.import File.open(pgp_key_path)
    crypto = GPGME::Crypto.new always_trust: true
    output_file = Tempfile.new([@file_basename, '.txt.pgp'])
    File.open @txt_file.path do |in_file|
      File.open output_file.path, 'wb' do |out_file|
        crypto.encrypt in_file, output: out_file, recipients: 'upperquadrant.com'
      end
    end
    output_file
  end

  def send_csv_as_attachment
    to = []
    operations_position = Position.find_by name: 'Operations Coordinator'
    senior_developer_position = Position.find_by name: 'Senior Software Developer'
    [operations_position, senior_developer_position].compact.each do |position|
      to = to.concat position.people.map(&:email)
    end
    NotificationMailer.simple_mail(to.uniq,
                                   "[SalesMakers] UQube Upload - #{Date.current.strftime('%m/%d/%Y')}",
                                   "See attachments(s). Confidential. For intended recipients only.",
                                   false,
                                   [@csv_file.path]
    ).deliver_later
  end
end