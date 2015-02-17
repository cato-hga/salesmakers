describe EmailProcessor do
  let(:vonage_account_processor) {
    email = build :email, :with_vonage_account_excel_attachment
    EmailProcessor.new email
  }
  let(:vonage_account_attachment) {
    vonage_account_processor.email.attachments.first
  }

  it 'recognizes an attachment' do
    expect(vonage_account_processor.email.attachments.first.size).to be > 1
  end

  context 'determining email acceptor' do
    it 'creates a tempfile with the proper extension' do
      tempfile = vonage_account_processor.create_tempfile(vonage_account_attachment)
      expect(tempfile.path[-5, tempfile.path.length]).to eq('.xlsx')
    end

    it 'determines the proper acceptor for Vonage account status changes' do
      expect(vonage_account_processor.acceptor(vonage_account_attachment)).
          to be_a(VonageAccountStatusChangesImporter)
    end
  end

end