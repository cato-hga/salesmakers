require 'rails_helper'
require 'net/sftp'

describe WalmartGiftCardFTPImporter, :vcr do
  let(:importer) { described_class.new }

  before(:each) do
    to_upload = File.new(Rails.root.join('spec', 'fixtures', 'SMI Orders for August 2015.xlsx'))
    Net::SFTP.start('ftp01.vonage.com', 'aatkinson', password: 'r7p9dbPM') do |sftp|
      dir_path = '/test'
      sftp.upload! to_upload.path, "#{dir_path}/#{DateTime.now.strftime('%Y%m%d%H%M%S')}-SMI Orders for August 2015.xlsx"
    end
  end

  after(:each) do
    Net::SFTP.start('ftp01.vonage.com', 'aatkinson', password: 'r7p9dbPM') do |sftp|
      dir_path = '/test'
      sftp.dir.glob(dir_path, '*.xlsx') do |file|
        sftp.rename! "#{dir_path}/#{file.name}",
                     "#{dir_path}/imported/#{DateTime.now.strftime('%Y%m%d%H%M%S')}-#{file.name}"
      end
    end
  end

  it 'saves records to the database' do
    expect {
      importer
    }.to change(WalmartGiftCard, :count).by(10)
  end

  it 'sends an email' do
    expect_any_instance_of(WalmartGiftCardMailer).to receive(:send_rbdc_check_email)
    importer
  end
end
