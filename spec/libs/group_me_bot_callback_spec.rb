describe GroupMeBotCallback do
  let(:callback_data) do
    {
        attachments: [
            type: 'image',
            url: 'http://i.groupme.com/123456789'
        ],
        avatar_url: "http://i.groupme.com/123456789",
        created_at: 1302623328,
        group_id: "1234567890",
        id: "1234567890",
        name: "John",
        sender_id: "12345",
        sender_type: "user",
        source_guid: "GUID",
        system: false,
        text: "!HELLO WORLD",
        user_id: "1234567890"
    }
  end

  context 'for initialization' do
    it 'succeeds with one parameter' do
      expect {
        described_class.new callback_data.to_json
      }.not_to raise_error
    end

    it 'fails without a parameter' do
      expect {
        described_class.new
      }.to raise_error(ArgumentError, %r{0 for 1})
    end
  end

  describe 'processing of json' do
    let(:callback) { described_class.new callback_data.to_json }

    it 'should set the group_id' do
      expect(callback.group_id).to eq(callback_data[:group_id])
    end

    it 'should set the name' do
      expect(callback.name).to eq(callback_data[:name])
    end

    it 'should set the system value' do
      expect(callback.system?).to eq(callback_data[:system])
    end

    it 'should set the text and downcase it' do
      expect(callback.text).to eq(callback_data[:text].downcase.sub('!', ''))
    end

    it 'should set the user_id' do
      expect(callback.user_id).to eq(callback_data[:user_id])
    end

    it 'should set attachments' do
      expect(callback.attachments.count).to eq(1)
    end
  end
end