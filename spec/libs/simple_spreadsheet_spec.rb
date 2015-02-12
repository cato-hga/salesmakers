describe SimpleSpreadsheet do
  let(:file) {
    File.new(Rails.root.join('spec', 'fixtures', 'UQube Import for FTP.xlsx'))
  }
  let(:roo_spreadsheet) { Roo::Spreadsheet.open(file.path)  }
  let(:spreadsheet) { described_class.new roo_spreadsheet }

  context 'initialization' do
    it 'does not throw an error with a Roo::Spreadsheet parameter' do
      expect {
        described_class.new roo_spreadsheet
      }.not_to raise_error
    end

    it 'throws an ArgumentError without a Roo::Spreadsheet' do
      expect {
        described_class.new
      }.to raise_error(ArgumentError, %r{0 for 1})
    end

    it 'starts processing' do
      expect_any_instance_of(described_class).to receive(:process)
      described_class.new roo_spreadsheet
    end
  end

  context 'processing' do
    it 'asks for the length of the longest row' do
      expect(spreadsheet).to receive(:find_longest_row_length)
      spreadsheet.process
    end

    it 'returns the correct longest row' do
      expect(spreadsheet.find_longest_row_length).to eq(6)
    end

    it 'returns the correct header row' do
      row = roo_spreadsheet.row 4
      spreadsheet.process
      expect(spreadsheet.header_row).to eq(row)
    end

    it 'sets header and rows' do
      expect(spreadsheet).to receive(:set_header_and_rows).with(6)
      spreadsheet.process
      expect(spreadsheet.header_row).to eq(roo_spreadsheet.row(4))
      expect(spreadsheet.rows.count).to eq(20)
    end

    it 'makes an array of hashes from header and rows' do
      expect(spreadsheet).to receive(:make_hashes)
      spreadsheet.process
      expect(spreadsheet.hashes.count).to eq(20)
    end
  end

end