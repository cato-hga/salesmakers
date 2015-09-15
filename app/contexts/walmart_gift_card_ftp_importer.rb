require 'net/sftp'

class WalmartGiftCardFTPImporter
  def initialize
    return if RunningProcess.running? self
    begin
      RunningProcess.running! self
      @files = []
      @gift_card_ids = []
      @gift_cards = []
      @saved_gift_cards = []
      Net::SFTP.start('ftp01.vonage.com', 'aatkinson', password: 'r7p9dbPM') do |sftp|
        if Rails.env.staging? || Rails.env.production?
          dir_path = '/rbd_eGift'
        else
          dir_path = '/test'
        end
        sftp.dir.glob(dir_path, '*.xlsx') do |file|
          temp_file = Tempfile.new(['giftcards', '.xlsx'])
          sftp.download! "#{dir_path}/#{file.name}", temp_file.path
          @files << File.new(temp_file.path)
          sftp.rename! "#{dir_path}/#{file.name}",
                       "#{dir_path}/imported/#{DateTime.now.strftime('%Y%m%d%H%M%S')}-#{file.name}" unless Rails.env.test?
        end
      end
      for file in @files do
        @file = file
        begin_processing
      end
      self
    ensure
      RunningProcess.shutdown! self
    end
  end

  def begin_processing
    set_spreadsheet
    return unless @spreadsheet
    process_row_hashes
    WalmartGiftCardMailer.send_card_pickup_email(@gift_cards.count).deliver_later unless @gift_cards.empty?
    store_all_cards
    WalmartGiftCardMailer.send_rbdc_check_email(@saved_gift_cards).deliver_later
    WalmartGiftCardMailer.send_card_details(@saved_gift_cards, nil, 'New Gift Cards from Import').deliver_later
    self
  end

  def process_row_hashes
    for row_hash in @spreadsheet.hashes do
      @gift_cards << translate(row_hash)
    end
  end

  def set_spreadsheet
    roo_spreadsheet = Roo::Spreadsheet.open(@file.path)
    @spreadsheet = SimpleSpreadsheet.new(roo_spreadsheet)
    unless @spreadsheet.header_row.include? 'URL'
      @spreadsheet = SimpleSpreadsheet.new(roo_spreadsheet, true)
    end
    self
  end

  def translate row_hash
    unique_code = nil
    link = nil
    challenge_code = nil
    row_hash.keys.each do |key|
      if key.is_a?(Fixnum)
        val = row_hash[key]
        if val.match(/\Ahttps\:\/\/getegiftcard\.walmart\.com.*\Z/)
          link = val
        elsif val.match(/\A[0-9]{2,4}\-[0-9]{4,10}\Z/)
          unique_code = val
        elsif val.match(/\A[0-9A-Za-z]{6}\Z/)
          challenge_code = val
        end
      else
        case key
          when "Unique ID"
            unique_code = row_hash[key]
          when "URL"
            link = row_hash[key]
          when "Challenge Code"
            challenge_code = row_hash[key]
        end
      end
    end
    return unless link && challenge_code
    walmart_gift_card = WalmartGiftCard.find_or_initialize_by link: link,
                                                              challenge_code: challenge_code
    walmart_gift_card.unique_code = unique_code if unique_code
    walmart_gift_card
  end

  def store_all_cards
    @gift_cards.compact.each { |card| store card }
  end

  def store walmart_gift_card
    walmart_gift_card.check
    if walmart_gift_card.save
      @saved_gift_cards << walmart_gift_card
    end
  end
end