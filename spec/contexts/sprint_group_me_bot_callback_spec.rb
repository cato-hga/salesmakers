require 'spec_helper'
require_relative '../../app/contexts/sprint_group_me_bot_callback'

describe SprintGroupMeBotCallback do
  let!(:sprint_group_me_bot) { create :sprint_group_me_bot }

  let(:callback_data) do
    {
        attachments: [
            {
                type: 'image',
                url: 'http://i.groupme.com/123456789'
            }
        ],
        avatar_url: "http://i.groupme.com/123456789",
        created_at: 1302623328,
        group_id: sprint_group_me_bot.group_num,
        id: "1234567890",
        name: "John",
        sender_id: "12345",
        sender_type: "user",
        source_guid: "GUID",
        system: false,
        text: "!atlanta mtd by rep",
        user_id: "1234567890"
    }
  end

  let(:hpa_callback_data) do
    {
        attachments: [
            {
                type: 'image',
                url: 'http://i.groupme.com/123456789'
            }
        ],
        avatar_url: "http://i.groupme.com/123456789",
        created_at: 1302623328,
        group_id: sprint_group_me_bot.group_num,
        id: "1234567890",
        name: "John",
        sender_id: "12345",
        sender_type: "user",
        source_guid: "GUID",
        system: false,
        text: "!atlanta hpa mtd by rep",
        user_id: "1234567890"
    }
  end

  context 'for initialization' do
    it 'succeeds with one parameter' do
      expect {
        SprintGroupMeBotCallback.new callback_data.to_json
      }.not_to raise_error
    end

    it 'fails without a parameter' do
      expect {
        SprintGroupMeBotCallback.new
      }.to raise_error(ArgumentError, %r{0 for 1})
    end
  end

  context 'for processing' do
    let(:callback) { SprintGroupMeBotCallback.new callback_data.to_json }
    let(:hpa_callback) { SprintGroupMeBotCallback.new hpa_callback_data.to_json }

    before { callback.process }

    it 'returns a query string with keywords stripped', :vcr do
      expect(callback.query_string).to eq('atlanta')
    end

    it 'returns keywords', :vcr do
      expect(callback.keywords.count).to eq(3)
    end

    it 'works for hpa as well', :vcr do
      hpa_callback.process
      expect(hpa_callback.query_string).to eq('atlanta')
      expect(callback.keywords.count).to eq(3)
    end
  end
end