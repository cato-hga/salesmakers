require 'roo'

describe VonageAccountStatusChangesImporter do
  let(:file) {
    File.new(Rails.root.join('spec', 'fixtures', 'UQube Import for FTP.xlsx'))
  }
  let(:importer) { described_class.new(file) }

  context 'initialization' do
    it 'raises no errors with one argument' do
      expect {
        described_class.new file
      }.not_to raise_error
    end

    it 'raises an ArgumentError with no arguments' do
      expect {
        described_class.new
      }.to raise_error(ArgumentError, %r{0 for 1})
    end

    it 'begins processing' do
      expect_any_instance_of(described_class).to receive(:begin_processing)
      described_class.new(file)
    end
  end

  describe 'processing' do
    it 'sets the spreadsheet' do
      expect(importer).to receive(:set_spreadsheet)
      importer.begin_processing
    end

    it 'gets a SimpleSpreadsheet' do
      expect(SimpleSpreadsheet).to receive(:new)
      importer
    end

    it 'processes each row hash' do
      expect(importer).to receive(:process_row_hashes)
      importer.begin_processing
    end

    it 'translates and stores at least one hash to a VonageAccountStatusChange' do
      expect(importer).to receive(:translate_and_store).at_least(1).times
      importer.begin_processing
    end
  end

  describe 'translation and storage' do
    it 'translates the hash' do
      expect(importer).to receive(:translate).exactly(20).times
      importer.begin_processing
    end

    it 'translate account status initials to symbols' do
      expect(importer).to receive(:status_from_initial).exactly(20).times
      importer.begin_processing
    end

    it 'sets up never-sold devices as terminations' do
      expect(importer).to receive(:never_been_sold_termination).exactly(20).times
      importer.begin_processing
    end

    it 'removes account end dates for non-terminated accounts' do
      expect(importer).to receive(:remove_termination_fields).exactly(20).times
      importer.begin_processing
    end

    it 'stores the status change record' do
      expect(importer).to receive(:store).exactly(20).times
      importer.begin_processing
    end

    it 'saves records to the database' do
      expect {
        importer
      }.to change(VonageAccountStatusChange, :count).by(20)
    end

    describe 'refund generation' do
      let!(:vonage_sale) {
        create :vonage_sale,
               mac: '0071CC1D416D'
        create :vonage_sale,
               mac: '0071CC44604D'
        new_sale = build :vonage_sale,
               mac: '0071CC43FF93',
               sale_date: Date.today - 31.days
        new_sale.save validate: false
      }

      it 'stores the refund' do
        importer.begin_processing
        expect(VonageRefund.count).to eq(2)
      end
    end

  end
end