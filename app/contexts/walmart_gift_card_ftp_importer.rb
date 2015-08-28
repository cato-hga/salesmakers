require 'net/sftp'

class WalmartGiftCardFTPImporter
  def initialize
    Net::SFTP.start('ftp01.vonage.com', 'aatkinson', password: 'r7p9dbPM') do |sftp|
      if Rails.env.staging? || Rails.env.production?
        dir_path = '/RBD_eGift'
      else
        dir_path = '/test'
      end
      sftp.dir.glob(dir_path, '*.xlsx') do |file|
        temp_file = Tempfile.new(['giftcards', '.xlsx'])
        sftp.download! "#{dir_path}/#{file.name}", temp_file.path
        @file = File.new(temp_file.path)
        begin_processing
        sftp.rename! "#{dir_path}/#{file.name}",
                     "#{dir_path}/imported/#{DateTime.now.strftime('%Y%m%d%H%M%S')}-#{file.name}" unless Rails.env.test?
      end
    end
    self
  end

  def begin_processing
    set_spreadsheet
    return unless @spreadsheet
    process_row_hashes
    self
  end

  def process_row_hashes
    for row_hash in @spreadsheet.hashes do
      translate_and_store(row_hash)
    end
  end

  def set_spreadsheet
    roo_spreadsheet = Roo::Spreadsheet.open(@file.path)
    @spreadsheet = SimpleSpreadsheet.new(roo_spreadsheet)
    self
  end

  def translate_and_store(row_hash)
    walmart_gift_card = translate(row_hash) || return
    store(walmart_gift_card)
  end

  def translate(row_hash)
    walmart_gift_card = WalmartGiftCard.new
    row_hash.keys.each do |key|
      case key
        when "Unique ID"
          walmart_gift_card.unique_code = row_hash[key]
        when "URL"
          walmart_gift_card.link = row_hash[key]
        when "Challenge Code"
          walmart_gift_card.challenge_code = row_hash[key]
      end
    end
    existing_gift_card = WalmartGiftCard.find_by link: walmart_gift_card.link
    walmart_gift_card = existing_gift_card || walmart_gift_card
    walmart_gift_card.check
    walmart_gift_card
  end

  def store(walmart_gift_card)
    walmart_gift_card.save
  end
end